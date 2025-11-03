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

  #   describe "POST /orders" do
  #     context "with testing_only token" do
  #       let(:order_params) do
  #         { order: { token: "testing_only" } }
  #       end

  #       it "creates a new order" do
  #         expect {
  #           post orders_path, params: order_params
  #         }.to change(Order, :count).by(1)
  #       end

  #       it "creates a subscription" do
  #         expect {
  #           post orders_path, params: order_params
  #         }.to change(Subscription, :count).by(1)
  #       end

  #       it "links the subscription to the order" do
  #         post orders_path, params: order_params
  #         order = Order.last
  #         expect(order.subscription).to be_present
  #       end

  #       it "links the subscription to the user" do
  #         post orders_path, params: order_params
  #         subscription = Subscription.last
  #         expect(subscription.user).to eq(user)
  #       end

  #       it "sets correct subscription dates" do
  #         post orders_path, params: order_params
  #         subscription = Subscription.last
  #         expect(subscription.start_date).to eq(Date.current)
  #         expect(subscription.end_date).to eq(Date.current + 1.month)
  #       end

  #       it "clears the cart" do
  #         post orders_path, params: order_params
  #         expect { cart.reload }.to raise_error(ActiveRecord::RecordNotFound)
  #       end

  #       it "redirects to the order complete page" do
  #         post orders_path, params: order_params
  #         order = Order.last
  #         expect(response).to redirect_to(complete_order_path(order))
  #       end

  #       it "sets order amounts correctly" do
  #         post orders_path, params: order_params
  #         order = Order.last
  #         expect(order.sub_total).to eq(Money.new(29900, "THB"))
  #         expect(order.total).to eq(Money.new(29900, "THB"))
  #       end

  #       it "creates an order item" do
  #         expect {
  #           post orders_path, params: order_params
  #         }.to change(OrderItem, :count).by(1)
  #       end

  #       it "links the order to the product through order_item" do
  #         post orders_path, params: order_params
  #         order = Order.last
  #         expect(order.product).to eq(product)
  #       end
  #     end

  #     context "order save fails" do
  #       before do
  #         allow_any_instance_of(Order).to receive(:save).and_return(false)
  #       end

  #       it "with testing_only token" do
  #         expect {
  #           post orders_path, params: { order: { token: "testing_only" } }
  #         }.not_to change(Order, :count)
  #       end

  #       it "with real payment token" do
  #         expect {
  #           post orders_path, params: { order: { token: "token_test_12345" } }
  #         }.not_to change(Order, :count)
  #       end
  #     end

  #     context "without a cart" do
  #       before do
  #         cart.destroy
  #       end

  #       it "redirects to new subscription path" do
  #         post orders_path, params: { order: { token: "testing_only" } }
  #         expect(response).to redirect_to(root_path)
  #       end

  #       it "shows an error message" do
  #         post orders_path, params: { order: { token: "testing_only" } }
  #         expect(flash[:alert]).to eq("No product in cart")
  #       end
  #     end

  #     context "with a real payment token" do
  #       let(:order_params) do
  #         { order: { token: "token_test_12345" } }
  #       end

  #       it "creates a new order" do
  #         expect {
  #           post orders_path, params: order_params
  #         }.to change(Order, :count).by(1)
  #       end

  #       it "creates a subscription" do
  #         expect {
  #           post orders_path, params: order_params
  #         }.to change(subscription, :count).by(1)
  #       end

  #       # Note: In the future, this should actually process payment with Omise
  #       # For now, it just creates the order and subscription
  #     end

  #     context "when subscription creation fails" do
  #       before do
  #         allow(subscriptionCreator).to receive(:new).and_return(double(call: false))
  #       end

  #       it "does not create subscription or save order" do
  #         expect {
  #           post orders_path, params: { order: { token: "testing_only" } }
  #         }.not_to change(subscription, :count)

  #         expect(Order.count).to eq(0)
  #       end

  #       it "shows an error message" do
  #         post orders_path, params: { order: { token: "testing_only" } }
  #         expect(flash[:alert]).to eq("Failed to create subscription")
  #       end
  #     end
  #   end
end
