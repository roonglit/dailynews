require 'rails_helper'

describe "Sign Out" do
  context "user is logged in" do
    before { @user = create(:user) }

    it "user can sign out in dropdown from your profile" do
      # user clicks on the avatar icon to sign in
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      # user fills in email and password, and sign in
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'
      click_link_or_button 'SIGN IN'

      # user clicks on the profile icon to sign out
      find('.user-profile').click
      click_button "Sign Out"

      # user can see sign up modal when user clicks user avatar
      find('.user-avatar').click
      expect(page).to have_content('Sign Up')
    end
  end
end
