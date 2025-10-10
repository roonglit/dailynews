require 'rails_helper'

describe "Sign In" do
  context "user exists" do
    before do
      @user = create(:user)
    end
    it "should be allows a user to login" do
      visit root_path
      find('.user-avatar').click
      click_link 'Sign in here'

      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'

      click_button 'SIGN IN'

      find('label[for="dropdown-toggle"]').click
      expect(page).to have_content('Sign Out')
    end

    it "should be switch to register modal when clicks Register here" do
      visit root_path

      find('span.iconify.lucide--circle-user-round').click

      click_link 'Sign in here'
      click_link 'Register here'

      expect(page).to have_content('Sign Up')
    end

    it "should be redirect to forgot password page when clicks forgot password in sign in dialog" do
      visit root_path

      find('span.iconify.lucide--circle-user-round').click
      click_link 'Sign in here'
      click_link 'Register here'

      click_link 'Forgot Password'
      expect(page).to have_content('Reset your password')
    end

    it "should be allows a user to login" do
      visit new_user_session_path

      fill_in 'email', with: @user.email
      fill_in 'password', with: 'password123'

      click_button 'SIGN IN'

      find('label[for="dropdown-toggle"]').click
      expect(page).to have_content('Sign Out')
    end
  end
end
