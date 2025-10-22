require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  let(:member) { create(:member) }
  let(:membership) { create(:membership, user: member, auto_renew: false) }

  before do
    sign_in member  # Devise helper
  end

  describe "GET /subscriptions" do
    it "returns http success" do
      get subscriptions_path
      expect(response).to have_http_status(:ok)
    end

    it "uses the account_setting layout (class-level check)" do
      expect(SubscriptionsController._layout).to eq("account_setting")
    end
  end

  describe "PATCH /subscriptions/:id" do
    it "updates auto_renew and redirects with notice" do
      patch subscription_path(membership), params: { membership: { auto_renew: true } }

      expect(response).to redirect_to(subscriptions_path)
      follow_redirect!
      expect(response.body).to include("Auto renew updated successfully.")

      membership.reload
      expect(membership.auto_renew).to be true
    end
  end
end
