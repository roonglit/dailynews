class AddOrderToMemberships < ActiveRecord::Migration[8.1]
  def change
    add_reference :memberships, :order, foreign_key: true
  end
end
