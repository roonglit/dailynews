class Order < ApplicationRecord
  belongs_to :user
  has_one :order_item, dependent: :destroy
  has_one :product, through: :order_item
  has_one :membership, dependent: :destroy

  monetize :total_cents, :sub_total_cents

  enum :state, { pending: 0, paid: 1, cancelled: 2 }

  # Virtual attribute for Omise token (not stored in database)
  attr_accessor :token

  before_save :stamp_total, if: -> { state_changed? && paid? }

  # Calculate total from product amount (always live)
  def calculated_total_cents
    product&.amount || 0
  end

  # Override total to return stamped value if paid, calculated value otherwise
  def total
    if paid?
      # Return stamped Money object from total_cents
      Money.new(total_cents, total_currency)
    else
      # Return calculated Money object from product
      Money.new(calculated_total_cents, total_currency)
    end
  end

  private

  def stamp_total
    self.total_cents = calculated_total_cents
  end
end
