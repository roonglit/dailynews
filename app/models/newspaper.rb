class Newspaper < ApplicationRecord
  has_one_attached :pdf
  has_one_attached :cover

  scope :order_by_created_at, -> { order(created_at: :asc) }

  scope :filter_by_month, ->(month, year = Time.zone.today.year) {
    if month.present?
      start_date = Time.zone.local(year, month.to_i, 1)
      end_date   = start_date.end_of_month.end_of_day
      where(published_at: start_date..end_date)
    else
      all
    end
  }
end
