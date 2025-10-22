require "rails_helper"

RSpec.describe "Checkout", type: :request do
    let(:product) { create(:subscribe_monthly) }

    let(:guest) { create(:guest) }
    let!(:guest_cart) { Cart.create!(user: guest) }
    let!(:guest_cart_item) { create(:cart_item, cart_id: guest_cart.id, product_id: product.id) }

    describe 'GET /checkout' do
        context 'When user without cart' do
            before do
                guest_cart.destroy
            end
            it 'Redirect to root_path and returns 302' do
                get "/checkout"
                expect(response).to redirect_to(root_path)
                expect(response).to have_http_status(302)
            end
        end

        # context 'When user is guest with cart' do
        #     it 'renders checkout page and returns 200' do
        #         get "/checkout"
        #         expect(response).to have_http_status(:ok)
        #         expect(response.body).to include("Checkout")
        #     end
        # end
    end
end
