require "rails_helper"

RSpec.describe "Checkout", type: :request do
    it "redirect to root_path" do
        create(:guest)
        
        get checkout_path

        expect(session[:member_return_to]).to eq('/checkout')
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
    end

    context "Signed in" do
        let!(:member) { create(:member) }
        let!(:member_cart) { create(:cart, user: member) }
        let!(:product) { create(:monthly_subscription_product) }
        let!(:member_cart_item) { create(:cart_item, cart: member_cart, product: product) }

        before do
            sign_in member
        end

        it "returns http success" do
            get checkout_path

            expect(response).to have_http_status(:success)
        end

        it "redirect to library when subscription active" do
            get library_path

            expect(response).to have_http_status(:success)
        end
    end

    context "Subscription Active" do
        let!(:member) { create(:member) }
        let!(:member_cart) { create(:cart, user: member) }
        let!(:product) { create(:monthly_subscription_product) }
        let!(:member_cart_item) { create(:cart_item, cart: member_cart, product: product) }
        let!(:subscription) { create(:subscription, member: member) }

        before do
            sign_in member
        end

        it "returns http success" do
            get checkout_path

            expect(response).to have_http_status(:redirect)
        end

        it "redirect to library when subscription active" do
            get checkout_path

            expect(flash[:notice]).to eq("You already have an active subscription. Enjoy reading!")
            expect(response).to have_http_status(:redirect)
        end
    end
end
