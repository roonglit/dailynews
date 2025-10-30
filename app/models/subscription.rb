class Subscription < ApplicationRecord
  belongs_to :member, foreign_key: :user_id
  belongs_to :order, optional: true

  validates :start_date, presence: true
  validates :end_date, presence: true

  scope :search, ->(query) {
    if query.present?
      term = "%#{query}%"
      joins(:user).where(
        "users.email ILIKE :term OR users.first_name ILIKE :term OR users.last_name ILIKE :term",
        term: term
      )
    else
      all
    end
  }

  def active?
    end_date >= Date.today
  end

  def editable?
    order.nil?
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
