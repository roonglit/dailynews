require 'rails_helper'

describe "First admin can create his own account", js: true do
  it "creates a new admin user account" do
    visit admin_root_path

    expect(page).to have_content("Admin Sign Up")

    email = "newadmin#{Time.now.to_i}@example.com"
    fill_in 'email', with: email
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

<<<<<<< Updated upstream:spec/system/admin/first_admin_can_create_his_own_account_spec.rb
=======
    # Should see success message and be redirected to sign in
>>>>>>> Stashed changes:spec/system/admin/first_user_can_create_admin_user_spec.rb
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    expect(Admin::User.find_by(email: email)).to be_present
  end

  context "when admin user already exists" do
    before { @admin_user = create(:admin_user) }

    it "allows admin user to sign in" do
      visit admin_root_path

      expect(page).to have_content("Admin Sign In")
      expect(page).to have_content("You need to sign in or sign up before continuing.")

      fill_in 'email', with: @admin_user.email
      fill_in 'password', with: 'password123'
      click_link_or_button 'SIGN IN'

      expect(page).to have_content("Signed in successfully.")
    end
  end
end
