require 'rails_helper'

RSpec.describe "Admin::Settings::Teams", type: :request do
  let!(:admin) { create(:admin_user) }

  before { sign_in admin }

  describe "GET /index" do
    it "returns http success" do
      get admin_settings_team_path

      expect(response).to have_http_status(:success)
    end

    it "default per_page when not specified" do
      get admin_settings_team_path

      expect(response.body.scan(/@example\.com/).size).to be <= 10
    end

    it "default per_page when per_page=0" do
      get admin_settings_team_path, params: { per_page: 0 }

      expect(response.body.scan(/@example\.com/).size).to be <= 10
    end
  end

  describe "PUT /update" do
    email = "new_admin@example.com"

    it "redirects to admin_settings_team_path" do
      put admin_settings_team_path, params: { admin_invitation: { email: email } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_settings_team_path)
    end
  end
end
