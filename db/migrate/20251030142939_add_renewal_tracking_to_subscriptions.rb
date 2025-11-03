class AddRenewalTrackingToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :renewal_status, :integer, default: 0, null: false
    add_column :subscriptions, :renewal_attempts, :integer, default: 0, null: false

    add_index :subscriptions, [ :auto_renew, :end_date, :renewal_status ],
              name: "index_subscriptions_on_renewal_query"
  end
end
