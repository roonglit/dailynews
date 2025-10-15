class Order < ApplicationRecord
  belongs_to :user
  has_one :order_item, dependent: :destroy
  has_one :product, through: :order_item

  monetize :total_cents, :sub_total_cents

  # Virtual attribute for Omise token (not stored in database)
  attr_accessor :token
end
