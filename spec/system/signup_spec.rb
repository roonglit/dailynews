require 'rails_helper'

describe "Sign Up" do
  it "allows a user to registration" do
    visit root_path

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

  it "can switch to sign in form on modal dialog" do
    # user clicks on the avatar icon to sign in
    visit root_path
    find('.user-avatar').click
    click_link 'Sign in here'

    # user should see a sign in form
    expect(page).to have_content('Sign In')
  end

  it "allows a user to registration from sign in page" do
    visit new_user_registration_path

    # user fills in email, password and confirm password, and sign up
    fill_in 'email', with: "register2@gmail.com"
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

    # user should see a welcome message
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
