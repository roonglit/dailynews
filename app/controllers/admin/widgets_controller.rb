module Admin
  class WidgetsController < BaseController
    def revenue
      current = revenue_for_month(Date.current.beginning_of_month)
      previous = revenue_for_month(Date.current.last_month.beginning_of_month)

      @title = "Revenue"
      @icon = "lucide--circle-dollar-sign"
      @current_value = format_money(current)
      @previous_value = format_money(previous)
      @percentage_change = calculate_percentage_change(current, previous)
      @format = :money
    end

    def active_subscriptions
      current = active_subscriptions_for_month(Date.current.beginning_of_month)
      previous = active_subscriptions_for_month(Date.current.last_month.beginning_of_month)

      @title = "Active Subscriptions"
      @icon = "lucide--newspaper"
      @current_value = current
      @previous_value = previous
      @percentage_change = calculate_percentage_change(current, previous)
      @format = :number
    end

    def customers
      current = customers_for_month(Date.current.beginning_of_month)
      previous = customers_for_month(Date.current.last_month.beginning_of_month)

      @title = "Total Customers"
      @icon = "lucide--users"
      @current_value = current
      @previous_value = previous
      @percentage_change = calculate_percentage_change(current, previous)
      @format = :number
    end

    def new_subscriptions
      current = new_subscriptions_for_month(Date.current.beginning_of_month)
      previous = new_subscriptions_for_month(Date.current.last_month.beginning_of_month)

      @title = "New Subscriptions"
      @icon = "lucide--trending-up"
      @current_value = current
      @previous_value = previous
      @percentage_change = calculate_percentage_change(current, previous)
      @format = :number
    end

    private

    def revenue_for_month(month_start)
      month_range = month_start..month_start.end_of_month
      Order.where(state: :paid, created_at: month_range).sum(:total_cents) / 100.0
    end

    def active_subscriptions_for_month(month_start)
      month_end = month_start.end_of_month
      Membership.where("start_date <= ? AND end_date >= ?", month_end, month_start).count
    end

    def customers_for_month(month_start)
      month_range = month_start..month_start.end_of_month
      User.where(created_at: month_range).count
    end

    def new_subscriptions_for_month(month_start)
      month_range = month_start..month_start.end_of_month
      Membership.where(created_at: month_range).count
    end

    def calculate_percentage_change(current, previous)
      return 0 if previous.zero?

      ((current - previous) / previous.to_f * 100).round(1)
    end

    def format_money(amount)
      "฿#{number_with_delimiter(amount, delimiter: ',', precision: 2)}"
    end

    def number_with_delimiter(number, options = {})
      ActionController::Base.helpers.number_with_delimiter(number, options)
    end
  end
end
