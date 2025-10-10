require 'rails_helper'

describe "Sign In", js: true do
  context "user exists" do
    before { @user = create(:user) }

    it "allows a user to login" do
      # user clicks on the avatar icon to sign in
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      # user fills in email and password, and sign in
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'
      click_link_or_button 'SIGN IN'

      # user should see a welcome message
      expect(page).to have_content('Signed in successfully.')
    end

    it "can switch back and forth between registraion and sign in" do
      # user clicks on the avatar icon to sign in
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      # user changes to register instead
      click_link 'Register here'

      # user should see the registration form
      expect(page).to have_content('Sign Up')
    end

    it "redirects user to forgot passwod page when user clicks forgot password" do
      # user clicks on the avatar icon to sign in
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      # user forgot his password
      click_link 'Forgot Password'

      # user should be able to start the forgot password process
      expect(page).to have_content('Reset your password')
    end

    it "allows a user to login from sign in page" do
      visit new_user_session_path

      # user fills in email and password, and sign in
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'
      click_button 'SIGN IN'

      # user should see a welcome message
      expect(page).to have_content('Signed in successfully.')
    end
  end
end
