class UpdateMonetizeToOrders < ActiveRecord::Migration[8.1]
  def change
    remove_column :orders, :total, :float
    remove_column :orders, :sub_total, :float
    add_monetize :orders, :total
    add_monetize :orders, :sub_total
  end
end
