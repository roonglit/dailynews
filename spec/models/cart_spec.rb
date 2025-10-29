require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:member) { create(:member) }
  let(:cart) { create(:cart, user: member) }
  let(:product) { create(:monthly_subscription_product) }

  context "product exists" do
    before { create(:cart_item, cart: cart, product: product) }

    it "" do
      expect(cart.total_cents).to eq(product.amount.cents)
    end
  end

  it "total_cents have not product" do
    expect(cart.total_cents).to eq(Money.new(0, "THB"))
  end
end
