require 'rails_helper'

RSpec.describe "Libraries", type: :request do
  let!(:member) { create(:member) }

  let!(:march_april_membership) { create(:membership, user: member, start_date: Date.new(2025, 3, 10), end_date: Date.new(2025, 4, 10)) }
  let!(:june_july_membership) { create(:membership, user: member, start_date: Date.new(2025, 6, 20), end_date: Date.new(2025, 7, 20)) }

  let!(:start_march)  { create(:newspaper, title: "No. 2025-03-05", published_at: Time.zone.parse("2025-03-05")) }
  let!(:mid_march)  { create(:newspaper, title: "No. 2025-03-15",  published_at: Time.zone.parse("2025-03-15")) }
  let!(:start_april) { create(:newspaper, title: "No. 2025-04-05", published_at: Time.zone.parse("2025-04-05")) }
  let!(:mid_april)  { create(:newspaper, title: "No. 2025-04-15", published_at: Time.zone.parse("2025-04-15")) }
  let!(:mid_june) { create(:newspaper, title: "No. 2025-06-20",   published_at: Time.zone.parse("2025-06-20")) }

  describe "GET /show" do
    it "redirect when not sign in" do
      get library_path
      expect(response).to have_http_status(:found)
    end

    context "sign in member" do
      before { sign_in member }

      it "shows newspapers within any membership ranges (uniq) when no month filter" do
        get library_path
        expect(response).to have_http_status(:ok)

        expect(response.body).not_to include("No. 2025-03-05")
        expect(response.body).to include("No. 2025-03-15")
        expect(response.body).to include("No. 2025-04-05")
        expect(response.body).not_to include("No. 2025-04-15")
        expect(response.body).to include("No. 2025-06-20")
      end

      it "filter month params june" do
        get library_path, params: { month: "6" }
        expect(response).to have_http_status(:ok)

        expect(response.body).not_to include("No. 2025-03-05")
        expect(response.body).not_to include("No. 2025-03-15")
        expect(response.body).not_to include("No. 2025-04-05")
        expect(response.body).not_to include("No. 2025-04-15")
        expect(response.body).to include("No. 2025-06-20")
      end
    end
  end
end
