class AddRenewalTimestampsToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :last_renewal_attempt_at, :datetime
    add_column :subscriptions, :renewal_succeeded_at, :datetime
    add_column :subscriptions, :renewal_failed_at, :datetime
  end
end
