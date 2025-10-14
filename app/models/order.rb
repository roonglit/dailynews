class Order < ApplicationRecord
  belongs_to :user
  has_one :order_item, dependent: :destroy
  has_one :product, through: :order_item
end
