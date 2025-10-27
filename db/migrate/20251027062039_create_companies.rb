class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :address_1, null: false
      t.string :address_2
      t.string :sub_district, null: false
      t.string :district, null: false
      t.string :province, null: false
      t.string :postal_code, null: false
      t.string :country, null: false
      t.string :phone_number, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :companies, :name, unique: true
  end
end
