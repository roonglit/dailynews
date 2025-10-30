class SubscriptionMailer < ApplicationMailer
  # Sent when a subscription renewal is successful
  def renewal_success(old_subscription, new_subscription)
    @old_subscription = old_subscription
    @new_subscription = new_subscription
    @member = old_subscription.member

    mail(
      to: @member.email,
      subject: "Your DAILYNEWS subscription has been renewed"
    )
  end

  # Sent when renewal fails 2 days before expiration (first attempt)
  def renewal_failed_day_2(subscription)
    @subscription = subscription
    @member = subscription.member

    mail(
      to: @member.email,
      subject: "Issue with your Daily News subscription renewal"
    )
  end

  # Sent when renewal fails 1 day before expiration (second attempt)
  def renewal_failed_day_1(subscription)
    @subscription = subscription
    @member = subscription.member

    mail(
      to: @member.email,
      subject: "Urgent: Daily News subscription renewal failed again"
    )
  end

  # Sent when renewal fails on expiration day (final attempt)
  def renewal_failed_final(subscription)
    @subscription = subscription
    @member = subscription.member

    mail(
      to: @member.email,
      subject: "Your Daily News subscription will expire today"
    )
  end
end
