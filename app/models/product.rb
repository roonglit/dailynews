class Product < ApplicationRecord
  has_one :cart_item, dependent: :destroy

  has_rich_text :description
  has_one :order_item, dependent: :destroy

  monetize :amount_cents

  validates :title, presence: true, uniqueness: true
  validates :sku, presence: true, uniqueness: true

  scope :order_by_created_at, -> { order(created_at: :asc) }

  # Tax rate constant (7% VAT)
  TAX_RATE = 0.07

  # Calculate base price (before tax) from tax-included amount
  def base_price
    return Money.new(0, "THB") unless amount_cents

    base_cents = (amount_cents / 1.07).round
    Money.new(base_cents, "THB")
  end

  # Calculate tax amount from tax-included amount
  def tax_amount
    return Money.new(0, "THB") unless amount_cents

    amount - base_price
  end

  # Get tax rate as percentage
  def tax_rate_percentage
    (TAX_RATE * 100).to_i
  end
end
