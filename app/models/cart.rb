class Cart < ApplicationRecord
  belongs_to :user

  has_one :cart_item, dependent: :destroy
  has_one :product, through: :cart_items
end
