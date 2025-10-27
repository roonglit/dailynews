class AddOmiseCustomerIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :omise_customer_id, :string, default: nil
  end
end
