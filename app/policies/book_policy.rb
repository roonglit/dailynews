class BookPolicy < ApplicationPolicy
  def show?
    # user.memberships.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.memberships.where("start_date <= ? and end_date >= ?", Date.today, Date.today).present?
        scope.all
      end
    end
  end
end
