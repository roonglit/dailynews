class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true

  def active?
    end_date >= Date.today
  end

  def cover_image
    first_newspaper&.cover
  end

  def first_newspaper
    Newspaper.where("published_at >= ? AND published_at <= ?", start_date, end_date)
              .order(published_at: :asc)
              .first
  end

  def renewal_or_expiry_date
    end_date
  end

  def renewal_text
    auto_renew? ? "Renews on" : "Expires on"
  end
end
