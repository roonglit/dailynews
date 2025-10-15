class Newspaper < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover

  scope :order_by_created_at, -> { order(created_at: :asc) }
end
