class AddChargeIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :charge_id, :string
  end
end
