require 'rails_helper'

describe "Sign Out" do
  context "user is logged in" do
    it "user can sign out in dropdown from your profile" do
      login_auth
      visit root_path

      find('label[for="dropdown-toggle"]').click

      click_button "Sign Out"

      find('span.iconify.lucide--circle-user-round').click
      expect(page).to have_content('Sign Up')
    end
  end
end
