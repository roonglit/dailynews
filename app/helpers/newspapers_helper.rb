module NewspapersHelper
  def check_newspaper_memberships(newspaper, user)
    # user&.memberships&.where("start_date <= ? and end_date >= ?", newspaper&.published_at&.to_date || newspaper.created_at.to_date, Date.today).present?

    user.memberships.each do |membership|
      if newspaper.published_at >= membership.start_date && newspaper.published_at <= membership.end_date
        return true
      end
    end
    false
  end
end
