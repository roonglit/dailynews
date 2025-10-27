require 'rails_helper'

RSpec.describe "Admin::Teams", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/teams/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/teams/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/admin/teams/create"
      expect(response).to have_http_status(:success)
    end
  end
end
