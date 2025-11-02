require 'rails_helper'

describe "Admin Can View Invitation Form" do
  it "shows the invitation form on settings page" do
    login_as_admin

    click_link_or_button "Settings"

    expect(page).to have_current_path(admin_settings_team_path)
    expect(page).to have_content("Invite Admin User")
    expect(page).to have_content("Send an invitation email to add a new admin user to your team.")
  end
end
