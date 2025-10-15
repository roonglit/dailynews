class MakeUserEmailOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :email, true
    change_column_default :users, :email, from: "", to: nil
    change_column_null :users, :encrypted_password, true
    change_column_default :users, :encrypted_password, from: "", to: nil
  end
end
