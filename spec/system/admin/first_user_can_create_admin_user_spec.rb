require 'rails_helper'

describe "Create Admin user" do
  it "user can create admin user account" do
    visit admin_root_path

    expect(page).to have_content("Admin Sign Up")

    fill_in 'email', with: "register1@gmail.com"
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  context "admin user exists" do
    before { @admin_user = create(:admin_user) }

    it "allows a admin user to login" do
      visit admin_root_path

      expect(page).to have_content("Admin Sign In")
      expect(page).to have_content("You need to sign in or sign up before continuing.")

      fill_in 'email', with: @admin_user.email
      fill_in 'password', with: 'password123'
      click_link_or_button 'SIGN IN'

      expect(page).to have_content("Signed in successfully.")
    end
  end

  context "when visiting with email param" do
    it "prefills and disables the email field" do
      visit "/admin/first_users/new?mail=abc@hotmail.com"

      expect(page).to have_content("Admin Sign Up")
      expect(page).to have_field("email", with: "abc@hotmail.com", readonly: true)
    end
  end
end
