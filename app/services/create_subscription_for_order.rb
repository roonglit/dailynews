class CreateSubscriptionForOrder
  attr_reader :order, :subscription, :previous_subscription

  def initialize(order, previous_subscription: nil)
    @order = order
    @previous_subscription = previous_subscription
  end

  def perform
    return false unless order.product

    @subscription = order.build_subscription(
      user_id: order.member.id,
      start_date: calculate_start_date,
      end_date: calculate_end_date
    )

    @subscription.save
  end

  private

  def calculate_start_date
    if previous_subscription
      # For renewals, start the day after the previous subscription ends
      previous_subscription.end_date + 1.day
    else
      # For new purchases, start immediately
      Date.current
    end
  end

  def calculate_end_date
    # Calculate end date relative to start date, not current date
    start_date = calculate_start_date

    case order.product.sku
    when "MEMBERSHIP_ONE_MONTH"
      start_date + 1.month
    when "MEMBERSHIP_MONTHLY_SUBSCRIPTION"
      start_date + 1.month
    else
      start_date + 1.month # Default to 1 month
    end
  end
end
