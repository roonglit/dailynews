require 'rails_helper'

describe "Admin Invitation Email Validation" do
  it "does not create invitation when email is blank" do
    login_as_admin

    click_link_or_button "Settings"

    expect {
      click_link_or_button "Send Invitation"
    }.not_to change(Admin::User, :count)

    expect(page).to have_current_path(admin_settings_team_path)
  end
end
