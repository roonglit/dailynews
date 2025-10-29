require 'rails_helper'

RSpec.configure do |config|
  config.before(:each) do
    FactoryBot.rewind_sequences
  end

  describe "Admin Teams" do
    context "when admin click Admin Teams button" do
      before { @admin_users = create_list(:admin_user, 5) }

      it "admin user can view all Admin Teams" do
        login_as_admin

        click_link_or_button "Admin Teams"

        expect(page).to have_current_path(admin_teams_path)
        expect(page).to have_content("6 Team Admins")
        expect(page).to have_content("admin1@example.com")
      end

      it "admin user can access member Invite Admin Teams page" do
        login_as_admin

        click_link_or_button "Admin Teams"
        click_link_or_button "Invite Team Members"

        expect(page).to have_current_path(new_admin_team_path)
        expect(page).to have_content("Invite Team Members")
        expect(page).to have_content("Enter the email addresses of people you want to invite.")
      end

      it "when admin press back from Invite Admin Teams should navigate to Admin Teams page" do
        login_as_admin

        click_link_or_button "Admin Teams"
        click_link_or_button "Invite Team Members"
        click_link_or_button "Back"

        expect(page).to have_current_path(admin_teams_path)
        expect(page).to have_content("6 Team Admins")
        expect(page).to have_content("admin1@example.com")
      end

      it "when admin press sent invite button with empty email should show error message box" do
        login_as_admin

        click_link_or_button "Admin Teams"
        click_link_or_button "Invite Team Members"
        click_link_or_button "Send Invite"

        expect(page).to have_current_path(new_admin_team_path)
        expect(page).to have_content("Email can't be blank")
        expect(page).not_to have_content("Invitation sent successfully.")
      end

      it "when admin press sent invite button with valid email should show success message box" do
        login_as_admin

        click_link_or_button "Admin Teams"
        click_link_or_button "Invite Team Members"

        fill_in 'invite_email', with: "admin10@hotmail.com"
        click_link_or_button "Send Invite"

        expect(page).to have_current_path(new_admin_team_path)
        expect(page).not_to have_content("Email can't be blank")
        expect(page).to have_content("Invitation sent successfully.")
      end
    end
  end
end
