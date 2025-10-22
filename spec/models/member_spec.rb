require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }
  let(:guest) { create(:guest) }

  let(:cart_member) { create(:cart, user_id: member.id) }
  let(:cart_guest) { create(:cart, user_id: guest.id) }

  let(:subscribe_monthly_product) { create(:subscribe_monthly) }

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
    before { create(:cart_item, cart_id: cart_guest.id, product_id: subscribe_monthly_product.id) }

    it "merge cart from guest" do
      member.merge_cart_from_guest(guest)
      expect(Cart.find_by(user_id: member.id).product.id).to eq(cart_guest.product.id)
    end
  end
end
