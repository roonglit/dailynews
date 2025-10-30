class AddStatusToAdminUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :admin_users, :status, :integer, null: false, default: 1
    add_index :admin_users, :status
  end
end
