class ChangeProductsNullConstraints < ActiveRecord::Migration[8.1]
  def change
    change_column_null :products, :title, false
    change_column_null :products, :amount, false
  end
end
