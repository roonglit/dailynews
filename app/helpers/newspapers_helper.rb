module NewspapersHelper
  def check_newspaper_memberships(newspaper, user)
    return false if user.nil? || user.guest?
    return false if newspaper&.published_at.nil?

    user.memberships.each do |membership|
      if newspaper.published_at >= membership.start_date && newspaper.published_at <= membership.end_date
        return true
      end
    end
    false
  end
end
