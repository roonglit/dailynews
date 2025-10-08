class Membership < ApplicationRecord
  belongs_to :user

  default_scope { order(id: :desc) }

  def active?
    start_date <= Date.today && end_date >= Date.today
  end
end
