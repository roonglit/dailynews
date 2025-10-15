class MembershipCreator
  attr_reader :order, :membership

  def initialize(order)
    @order = order
  end

  def call
    return false unless order.product

    @membership = order.build_membership(
      user: order.user,
      start_date: Date.current,
      end_date: calculate_end_date
    )

    @membership.save
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
