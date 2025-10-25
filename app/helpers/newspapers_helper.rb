module NewspapersHelper
  def check_newspaper_subscriptions(newspaper, user)
    return false if user.nil? || user.guest?
    return false if newspaper&.published_at.nil?

    user.subscriptions.each do |subscription|
      if newspaper.published_at >= subscription.start_date && newspaper.published_at <= subscription.end_date
        return true
      end
    end
    false
  end
end
