require 'rails_helper'

RSpec.describe "CartItems", type: :request do
  let(:user) { create(:member) }
  let!(:product) { create(:monthly_subscription_product) }
  let!(:cart) { Cart.create!(user: user) }

  before do
    sign_in user
  end

  describe "POST /cart_items" do
    context "without product" do
      before { product.destroy }

      it "redirects to root path" do
        post cart_items_path, params: { cart_item: { sku: "INVALID" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "product exists and can save cart_item" do
      it "creates or updates cart_item and redirects to checkout" do
        post cart_items_path, params: { sku: product.sku }

        expect(response).to redirect_to(checkout_path)

        expect(cart.reload.cart_item.product).to eq(product)
      end
    end

    context "product exists and fail to save cart_item" do
      before do
        allow_any_instance_of(CartItem).to receive(:save).and_return(false)
      end

      it "redirects to root with alert" do
        post cart_items_path, params: { sku: product.sku }

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
