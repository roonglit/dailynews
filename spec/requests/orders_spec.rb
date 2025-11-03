require 'rails_helper'

RSpec.describe "/orders", type: :request do
  let(:user) { create(:member) }
  let(:product) { create(:product, sku: "subscription_ONE_MONTH", title: "1 Month", amount: 299) }
  let(:cart) { Cart.create!(user: user) }
  let(:cart_item) { CartItem.create!(cart: cart, product: product) }

  before do
    sign_in user
  end

  describe "GET /orders/:id/complete" do
    let(:order) { create(:order, user_id: user.id) }

    it "returns a successful response" do
      get complete_order_path(order)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /orders" do
    it "no product in cart" do
      cart
      post orders_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("No product in cart")
    end
  end
end
