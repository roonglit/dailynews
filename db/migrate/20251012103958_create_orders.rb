class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.monetize :amount, default: "THB"

      t.timestamps
    end
  end
end
