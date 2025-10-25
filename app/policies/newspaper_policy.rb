class NewspaperPolicy < ApplicationPolicy
  def show?
    # Members with active subscriptions can read
    # Guests cannot read (need to become members first)
    user.member? && user.subscriptions.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # Only members with active subscriptions can see newspapers
      if user.member? && user.subscriptions.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
        scope.all
      else
        scope.none
      end
    end
  end
end
