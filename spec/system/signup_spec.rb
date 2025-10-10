require 'rails_helper'

describe "Sign Up" do
  it "should be allows a user to register in modal dialog" do
    visit root_path

    find('.user-avatar').click

    fill_in 'email', with: 'register1@gmail.com'
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'

    click_button 'SIGN UP'

    find('label[for="dropdown-toggle"]').click
    expect(page).to have_content('Sign Out')
  end

  it "should be switch to login modal when clicks Sign in here" do
    visit root_path

    find('span.iconify.lucide--circle-user-round').click

    click_link 'Sign in here'

    expect(page).to have_content('Sign In')
  end

  it "should be allows a user to register in registration page" do
    visit new_user_registration_path

    fill_in 'email', with: 'register2@gmail.com'
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'

    click_button 'SIGN UP'

    find('label[for="dropdown-toggle"]').click
    expect(page).to have_content('Sign Out')
  end
end
