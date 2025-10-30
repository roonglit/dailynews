class Subscription < ApplicationRecord
  belongs_to :member, foreign_key: :user_id
  belongs_to :order, optional: true

  enum :renewal_status, {
    pending: 0,
    processing: 1,
    succeeded: 2,
    failed: 3
  }, default: :pending

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

  # Returns the date when renewal will be attempted (2 days before expiration)
  def renewal_attempt_date
    return nil unless auto_renew?
    end_date - 2.days
  end

  # Returns a human-readable status of the renewal process
  def renewal_status_message
    return nil unless auto_renew?

    case renewal_status
    when "pending"
      if renewal_attempts > 0
        "Renewal in progress, will retry"
      else
        "Auto-renewal enabled"
      end
    when "processing"
      "Renewal in progress"
    when "succeeded"
      "Successfully renewed"
    when "failed"
      days_until_expiry = (end_date - Date.current).to_i
      if days_until_expiry > 0
        "Renewal failed, will retry in #{days_until_expiry} #{'day'.pluralize(days_until_expiry)}"
      else
        "Renewal failed, subscription expired"
      end
    end
  end

  # Returns whether renewal needs attention (failed and expiring soon)
  def renewal_needs_attention?
    auto_renew? && failed? && (end_date - Date.current).to_i <= 1
  end

  # Returns detailed renewal information for display
  def renewal_details
    return nil unless auto_renew?

    details = {}
    details[:status] = renewal_status
    details[:attempts] = renewal_attempts
    details[:last_attempt_at] = last_renewal_attempt_at
    details[:succeeded_at] = renewal_succeeded_at
    details[:failed_at] = renewal_failed_at
    details[:next_attempt_date] = failed? ? end_date : renewal_attempt_date
    details[:needs_attention] = renewal_needs_attention?
    details
  end
end
