class Order < ApplicationRecord
  belongs_to :member, foreign_key: :user_id
  has_one :order_item, dependent: :destroy
  has_one :product, through: :order_item
  has_one :subscription, dependent: :destroy

  monetize :total_cents, :sub_total_cents

  enum :state, { pending: 0, paid: 1, cancelled: 2 }

  # Virtual attribute for Omise token (not stored in database)
  attr_accessor :token
end
