require 'rails_helper'

RSpec.describe "Admin::Overviews", type: :request do
  let!(:admin) { create(:admin_user) }
  before { sign_in admin }
  describe "GET /show" do
    it "returns http success" do
      get admin_overview_path
      expect(response).to have_http_status(:success)
    end
  end
end
