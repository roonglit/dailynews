module SubscriptionsHelper
  def subscription_cover_image(subscription)
    if subscription.cover_image&.attached?
      subscription.cover_image
    else
      # Return placeholder image path or asset
      "placeholder-subscription.png"
    end
  end

  def format_renewal_date(date)
    date.strftime("%b %d, %Y")
  end
end
