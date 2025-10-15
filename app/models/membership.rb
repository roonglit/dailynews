class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true
end
