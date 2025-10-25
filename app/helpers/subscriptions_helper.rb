module SubscriptionsHelper
  def subscription_cover_image(membership)
    if membership.cover_image&.attached?
      membership.cover_image
    else
      # Return placeholder image path or asset
      "placeholder-subscription.png"
    end
  end

  def format_renewal_date(date)
    date.strftime("%b %d, %Y")
  end
end
