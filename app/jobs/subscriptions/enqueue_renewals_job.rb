module Subscriptions
  class EnqueueRenewalsJob < ApplicationJob
    queue_as :default

    def perform
      # Find subscriptions that:
      # - Have auto-renewal enabled
      # - Are expiring in the next 0-2 days
      # - Haven't been successfully processed yet (pending or failed)
      expiring_subscriptions = Subscription
        .where(auto_renew: true)
        .where("end_date BETWEEN ? AND ?", Date.current, Date.current + 2.days)
        .where(renewal_status: [:pending, :failed])
        .includes(:member, order: :product)

      expiring_subscriptions.find_each do |subscription|
        # Skip if user already has a newer subscription (prevents duplicate renewals)
        next if subscription.member.subscriptions
          .where("start_date > ? AND order_id IS NOT NULL", subscription.end_date)
          .exists?

        # Mark as processing to prevent duplicate job execution
        subscription.processing!

        # Enqueue the renewal processing job
        Subscriptions::ProcessRenewalJob.perform_later(subscription.id)
      end
    end
  end
end
