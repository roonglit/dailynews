require 'rails_helper'

describe "Admin Teams" do
  context "when viewing the teams list" do
    it "displays all admin team members" do
      admins = create_list(:admin_user, 5)
      login_as_admin

      click_link_or_button "Admin Teams"

      expect(page).to have_current_path(admin_teams_path)
      expect(page).to have_content("6 Team Admins")
      expect(page).to have_content(admins.first.email)
    end
  end

  context "when navigating to the invitation form" do
    it "shows the invitation form" do
      login_as_admin

      click_link_or_button "Admin Teams"
      click_link_or_button "Invite Team Members"

      expect(page).to have_current_path(new_admin_team_path)
      expect(page).to have_content("Invite Team Members")
      expect(page).to have_content("Enter the email addresses of people you want to invite.")
    end

    it "returns to team list when clicking back" do
      admins = create_list(:admin_user, 5)
      login_as_admin

      click_link_or_button "Admin Teams"
      click_link_or_button "Invite Team Members"
      click_link_or_button "Back"

      expect(page).to have_current_path(admin_teams_path)
      expect(page).to have_content("6 Team Admins")
      expect(page).to have_content(admins.first.email)
    end
  end
end
