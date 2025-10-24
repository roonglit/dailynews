require 'rails_helper'

RSpec.describe "Admin::Subscriptions", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get admin_subscription_path
      expect(response).to have_http_status(:success)
    end
  end

end
