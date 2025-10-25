class RenameMembershipsToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    rename_table :memberships, :subscriptions
  end
end
