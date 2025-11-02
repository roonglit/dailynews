require 'rails_helper'

describe "Admin Can View Team Members List" do
  it "displays all admin team members via Settings" do
    admins = create_list(:admin_user, 5)
    login_as_admin

    click_link_or_button "Settings"

    expect(page).to have_current_path(admin_settings_team_path)
    expect(page).to have_content("6 admin users")
    expect(page).to have_content(admins.first.email)
  end

  it "displays team members when visiting settings page directly" do
    admins = create_list(:admin_user, 5)
    login_as_admin

    visit admin_settings_team_path

    expect(page).to have_current_path(admin_settings_team_path)
    expect(page).to have_content("6 admin users")
    expect(page).to have_content(admins.first.email)
  end
end
