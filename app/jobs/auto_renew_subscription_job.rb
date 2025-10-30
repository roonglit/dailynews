class AutoRenewSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(subscription_id)
    subscription = Subscription.find(subscription_id)

    product = subscription.order.product
    return if product.blank?

    amount_cents = product.amount_cents

    member = subscription.member

    customer = Omise::Customer.retrieve(member.omise_customer_id)

    order = member.orders.create!(
      total_cents: amount_cents,
      sub_total_cents: (amount_cents / 1.07).round
    )
    order.create_order_item(product: product)

    charge = Omise::Charge.create({
      amount: amount_cents,
      currency: "thb",
      customer: customer.id,
      recurring_reason: "subscription"
    })

    order.update(charge_id: charge.id)

    if charge.paid
      order.paid!
      if CreateSubscriptionForOrder.new(order).perform
        ClearCurrentUserCart.new(order.member).perform
      end
    else
      order.cancelled!
    end
  end
end
