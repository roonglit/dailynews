class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :amount
      t.timestamps
    end
  end
end
