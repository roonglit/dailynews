require 'rails_helper'

RSpec.describe "Admin::Subscriptions", type: :request do
  let!(:admin) { create(:admin_user) }

  before { sign_in admin }

  describe "GET /index" do
    it "returns http success" do
      get admin_subscriptions_path()

      expect(response).to have_http_status(:success)
    end
  end
end
