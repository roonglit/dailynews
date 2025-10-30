require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }
  let(:guest) { create(:guest) }

  let(:cart_member) { create(:cart, user_id: member.id) }
  let(:cart_guest) { create(:cart, user_id: guest.id) }

  let(:subscribe_monthly_product) { create(:monthly_subscription_product) }

  it "user is guest?" do
    expect(member.guest?).to eq(false)
  end

  it "user is member?" do
    expect(member.member?).to eq(true)
  end

  it "get email from user" do
    expect(member.name).to eq(member.email)
  end

  context "guest no have cart item" do
    it "cart item is nil" do
      expect(member.merge_cart_from_guest(guest)).to be_nil
    end
  end

  context "guest have cart item" do
    before { create(:cart_item, cart: cart_guest, product: subscribe_monthly_product) }

    it "merge cart from guest" do
      member.merge_cart_from_guest(guest)

      expect(member.cart.product).to eq(subscribe_monthly_product)
    end
  end
end
