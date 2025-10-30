class DailySubscriptionCheckJob < ApplicationJob
  queue_as :default

  def perform
    Subscription.where(auto_renew: true).each do |subscription|
      # member = subscription.member
      # next if member.subscriptions.last.end_date >= Date.today

      AutoRenewSubscriptionJob.perform_later(subscription.id)
    end
  end
end
