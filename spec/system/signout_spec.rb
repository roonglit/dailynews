require 'rails_helper'

describe "Sign Out", js: true do
  context "user exists" do
    before { @user = create(:user) }

    it "allows user to sign out" do
      # user clicks on the avatar icon to sign in
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      # user fills in email and password, and sign in
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'
      click_link_or_button 'SIGN IN'

      # expect user to be successfully signed in
      expect(page).to have_content('Signed in successfully.')

      # user clicks on the profile icon to sign out
      find('.user-profile').click
      click_link_or_button "Sign Out"

      # user can see sign up modal when user clicks user avatar
      find('.user-avatar').click
      expect(page).to have_content('Signed out successfully.')
    end
  end
end
