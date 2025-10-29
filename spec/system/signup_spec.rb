require 'rails_helper'

describe "Sign Up", js: true do
  it "allows a user to register" do
    # user clicks on the avatar icon to sign up
    visit root_path
    find('.user-avatar').click

    # user fills in email, password and confirm password, and sign up
    fill_in 'email', with: "register1@gmail.com"
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

    # user should see a welcome message
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  it "allows a user to register from sign up page" do
    visit new_member_registration_path

    # user fills in email, password and confirm password, and sign up
    fill_in 'email', with: "register2@gmail.com"
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

    # user should see a welcome message
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
