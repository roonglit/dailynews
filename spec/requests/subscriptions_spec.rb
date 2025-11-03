require "rails_helper"

RSpec.describe "Subscriptions", type: :request do
  let(:member) { create(:member) }
  let(:subscription) { create(:subscription, member: member, auto_renew: false) }

  before do
    sign_in member  # Devise helper
  end

  describe "GET /subscriptions" do
    it "returns http success" do
      get account_subscriptions_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /subscriptions/:id" do
    it "updates auto_renew and redirects with notice" do
      patch account_subscription_path(subscription), params: { subscription: { auto_renew: true } }

      expect(response).to redirect_to(account_subscriptions_path)
      follow_redirect!
      expect(response.body).to include("Auto renew updated successfully.")

      subscription.reload
      expect(subscription.auto_renew).to be true
    end
  end
end
