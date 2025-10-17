class AddAutoRenewToMembership < ActiveRecord::Migration[8.1]
  def change
    add_column :memberships, :auto_renew, :boolean, default: true
  end
end
