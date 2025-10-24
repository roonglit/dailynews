require 'rails_helper'

RSpec.describe "Admin::Overviews", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/admin/overviews/show"
      expect(response).to have_http_status(:success)
    end
  end

end
