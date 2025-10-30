require 'rails_helper'

RSpec.describe "Admin::Teams", type: :request do
  let!(:admin) { create(:admin_user) }

  before { sign_in admin }

  describe "GET /index" do
    it "returns http success" do
      get admin_teams_path

      expect(response).to have_http_status(:success)
    end

    it "default per_page when not specified" do
      get admin_teams_path

      expect(response.body.scan(/@example\.com/).size).to be <= 10
    end

    it "default per_page when per_page=0" do
      get admin_teams_path, params: { per_page: 0 }

      expect(response.body.scan(/@example\.com/).size).to be <= 10
    end
  end

  describe "POST /invite" do
    email = "new_admin@example.com"

    it "redirects to new_admin_team_path" do
      post invite_admin_teams_path, params: { invite: { email: email } }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(new_admin_team_path)
    end
  end
end
