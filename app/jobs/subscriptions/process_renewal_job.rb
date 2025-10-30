module Subscriptions
  class ProcessRenewalJob < ApplicationJob
    queue_as :default

    def perform(subscription_id)
      subscription = Subscription.find(subscription_id)

      # Increment attempt counter and stamp attempt time
      subscription.increment!(:renewal_attempts)
      subscription.update!(last_renewal_attempt_at: Time.current)

      product = subscription.order.product
      if product.blank?
        handle_failure(subscription, "Product not found")
        return
      end

      amount_cents = product.amount_cents
      member = subscription.member

      # Retrieve saved Omise customer
      customer = Omise::Customer.retrieve(member.omise_customer_id)

      # Create new order
      order = member.orders.create!(
        total_cents: amount_cents,
        sub_total_cents: (amount_cents / 1.07).round
      )
      order.create_order_item(product: product)

      # Charge the customer (no 3DS for recurring payments)
      charge = Omise::Charge.create({
        amount: amount_cents,
        currency: "thb",
        customer: customer.id,
        recurring_reason: "subscription"
      })

      order.update(charge_id: charge.id)

      if charge.paid
        handle_success(subscription, order)
      else
        handle_failure(subscription, charge.failure_message)
      end
    rescue Omise::Error => e
      handle_failure(subscription, e.message)
      raise e
    rescue StandardError => e
      Rails.logger.error("Subscription renewal failed: #{e.message}")
      handle_failure(subscription, "System error occurred")
      raise e
    end

    private

    def handle_success(subscription, order)
      order.paid!
      subscription.update!(
        renewal_status: :succeeded,
        renewal_succeeded_at: Time.current
      )

      # Create new subscription starting after the old one ends
      if CreateSubscriptionForOrder.new(order, previous_subscription: subscription).perform
        ClearCurrentUserCart.new(order.member).perform

        # Send success email
        SubscriptionMailer.renewal_success(subscription, order.subscription).deliver_later
      end
    end

    def handle_failure(subscription, error_message)
      subscription.update!(
        renewal_status: :failed,
        renewal_failed_at: Time.current
      )

      Rails.logger.error("Subscription renewal failed for subscription #{subscription.id}: #{error_message}")

      # Send appropriate failure email based on attempt number and days until expiration
      days_until_expiry = (subscription.end_date - Date.current).to_i
      attempt = subscription.renewal_attempts

      if days_until_expiry > 1
        # Day -2: First failure, we'll retry tomorrow
        SubscriptionMailer.renewal_failed_day_2(subscription).deliver_later
      elsif days_until_expiry == 1
        # Day -1: Second failure, last attempt tomorrow
        SubscriptionMailer.renewal_failed_day_1(subscription).deliver_later
      else
        # Day 0: Final failure, subscription will expire
        SubscriptionMailer.renewal_failed_final(subscription).deliver_later
      end
    end
  end
end
