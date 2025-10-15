class Product < ApplicationRecord
  has_one :cart_item, dependent: :destroy

  has_rich_text :description
  has_one :order_item, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :amount, presence: true
end
