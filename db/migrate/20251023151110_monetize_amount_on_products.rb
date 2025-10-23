class MonetizeAmountOnProducts < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :amount, :integer
    add_monetize :products, :amount
  end
end
