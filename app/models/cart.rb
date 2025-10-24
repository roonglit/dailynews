class Cart < ApplicationRecord
  belongs_to :user

  has_one :cart_item, dependent: :destroy
  has_one :product, through: :cart_item

  def total
    amount = product&.amount || Money.new(0, "THB")
    amount.cents
  end
end
