class AddStateToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :state, :integer, default: 0, null: false
    add_index :orders, :state
  end
end
