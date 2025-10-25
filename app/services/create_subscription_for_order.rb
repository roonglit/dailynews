class CreateSubscriptionForOrder
  attr_reader :order, :subscription

  def initialize(order)
    @order = order
  end

  def perform
    return false unless order.product

    @subscription = order.build_subscription(
      user: order.member,
      start_date: Date.current,
      end_date: calculate_end_date
    )

    @subscription.save
  end

  private

  def calculate_end_date
    case order.product.sku
    when "MEMBERSHIP_ONE_MONTH"
      Date.current + 1.month
    when "MEMBERSHIP_MONTHLY_SUBSCRIPTION"
      Date.current + 1.month
    else
      Date.current + 1.month # Default to 1 month
    end
  end
end
