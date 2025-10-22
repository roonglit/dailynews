require 'rails_helper'

RSpec.describe "/newspaper", type: :request do
  let!(:member) { create(:member) }
  let!(:newspaper) { create(:newspaper, published_at: Time.current) }

  describe "GET /newspaper/:id (show)" do
    it "redirect when not sign in" do
      get newspaper_path(newspaper)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_member_session_path)
    end
  end
end
