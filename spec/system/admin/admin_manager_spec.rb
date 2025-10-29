require 'rails_helper'

describe "Manage Admin user" do
  context "when admin click subscription button" do
    before { @admin_user = create(:admin_user) }

    it "admin user can access member subscription" do
      login_as_admin

      click_link_or_button "Subscriptions"

      expect(page).to have_content("Subscriptions")
    end
  end
end
