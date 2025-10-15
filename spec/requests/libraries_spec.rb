require 'rails_helper'

RSpec.describe "Libraries", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/libraries/show"
      expect(response).to have_http_status(:success)
    end
  end

end
