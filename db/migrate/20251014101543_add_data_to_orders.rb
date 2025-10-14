class AddDataToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :sub_total, :float
    add_column :orders, :total, :float
    add_reference :orders, :user, null: false, foreign_key: true
  end
end
