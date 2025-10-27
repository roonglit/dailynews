class Order < ApplicationRecord
  belongs_to :member, foreign_key: :user_id
  has_one :order_item, dependent: :destroy
  has_one :product, through: :order_item
  has_one :subscription, dependent: :destroy

  monetize :total_cents, :sub_total_cents

  enum :state, { pending: 0, paid: 1, cancelled: 2 }

  # Virtual attribute for Omise token (not stored in database)
  attr_accessor :token

  # Tax rate constant (7% VAT)
  TAX_RATE = 0.07

  # Calculate base price (before tax) from tax-included total
  def base_price
    return Money.new(0, "THB") unless total_cents

    base_cents = (total_cents / 1.07).round
    Money.new(base_cents, "THB")
  end

  # Calculate tax amount from tax-included total
  def tax_amount
    return Money.new(0, "THB") unless total_cents

    Money.new(total_cents, "THB") - base_price
  end

  # Get tax rate as percentage
  def tax_rate_percentage
    (TAX_RATE * 100).to_i
  end
end
