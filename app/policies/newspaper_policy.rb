class NewspaperPolicy < ApplicationPolicy
  def show?
    # Members with active memberships can read
    # Guests cannot read (need to become members first)
    user.member? && user.memberships.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      # Only members with active memberships can see newspapers
      if user.member? && user.memberships.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
        scope.all
      else
        scope.none
      end
    end
  end
end
