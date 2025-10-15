require 'rails_helper'

RSpec.describe "/orders", type: :request do
  let(:user) { create(:member) }
  let(:product) { create(:product, sku: "MEMBERSHIP_ONE_MONTH", title: "1 Month", amount: 299) }
  let!(:cart) { Cart.create!(user: user) }
  let!(:cart_item) { CartItem.create!(cart: cart, product: product) }

  before do
    sign_in user
  end

  describe "POST /orders" do
    context "with testing_only token" do
      let(:order_params) do
        { order: { token: "testing_only" } }
      end

      it "creates a new order" do
        expect {
          post orders_path, params: order_params
        }.to change(Order, :count).by(1)
      end

      it "creates a membership" do
        expect {
          post orders_path, params: order_params
        }.to change(Membership, :count).by(1)
      end

      it "links the membership to the order" do
        post orders_path, params: order_params
        order = Order.last
        expect(order.membership).to be_present
      end

      it "links the membership to the user" do
        post orders_path, params: order_params
        membership = Membership.last
        expect(membership.user).to eq(user)
      end

      it "sets correct membership dates" do
        post orders_path, params: order_params
        membership = Membership.last
        expect(membership.start_date).to eq(Date.current)
        expect(membership.end_date).to eq(Date.current + 1.month)
      end

      it "clears the cart" do
        post orders_path, params: order_params
        expect { cart.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects to the order complete page" do
        post orders_path, params: order_params
        order = Order.last
        expect(response).to redirect_to(complete_order_path(order))
      end

      it "sets order amounts correctly" do
        post orders_path, params: order_params
        order = Order.last
        expect(order.sub_total).to eq(Money.new(29900, "THB"))
        expect(order.total).to eq(Money.new(29900, "THB"))
      end

      it "creates an order item" do
        expect {
          post orders_path, params: order_params
        }.to change(OrderItem, :count).by(1)
      end

      it "links the order to the product through order_item" do
        post orders_path, params: order_params
        order = Order.last
        expect(order.product).to eq(product)
      end
    end

    context "without a cart" do
      before do
        cart.destroy
      end

      it "redirects to new membership path" do
        post orders_path, params: { order: { token: "testing_only" } }
        expect(response).to redirect_to(new_membership_path)
      end

      it "shows an error message" do
        post orders_path, params: { order: { token: "testing_only" } }
        expect(flash[:alert]).to eq("No product in cart")
      end
    end

    context "with a real payment token" do
      let(:order_params) do
        { order: { token: "tokn_test_12345" } }
      end

      it "creates a new order" do
        expect {
          post orders_path, params: order_params
        }.to change(Order, :count).by(1)
      end

      it "creates a membership" do
        expect {
          post orders_path, params: order_params
        }.to change(Membership, :count).by(1)
      end

      # Note: In the future, this should actually process payment with Omise
      # For now, it just creates the order and membership
    end
  end
end
