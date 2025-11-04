require 'rails_helper'

describe "Admin can manage team", js: true do
  context "when admin is signed in with multiple team members" do
    let!(:admins) { create_list(:admin_user, 5) }

    before do
      login_as_admin
    end

    it "displays all admin team members via Settings" do
      click_link_or_button "Settings"

      expect(page).to have_current_path(admin_settings_team_path)
      expect(page).to have_content("6 admin users")
      expect(page).to have_content(admins.first.email)
    end

    it "displays team members when visiting settings page directly" do
      visit admin_settings_team_path

      expect(page).to have_current_path(admin_settings_team_path)
      expect(page).to have_content("6 admin users")
      expect(page).to have_content(admins.first.email)
    end
  end

  context "when admin is signed in" do
    before do
      login_as_admin
    end

    it "shows the invitation form on settings page" do
      click_link_or_button "Settings"

      expect(page).to have_current_path(admin_settings_team_path)
      expect(page).to have_content("Invite Admin User")
      expect(page).to have_content("Send an invitation email to add a new admin user to your team.")
    end

    it "creates invitation with valid email" do
      click_link_or_button "Settings"

      expect {
        fill_in 'admin_invitation_email', with: "admin10@hotmail.com"
        click_link_or_button "Send Invitation"
      }.to change(Admin::User, :count).by(1)

      expect(page).to have_current_path(admin_settings_team_path)
      expect(page).to have_content("admin10@hotmail.com")
    end

    it "creates Admin::User with invited status and Admin::Invitation record" do
      click_link_or_button "Settings"

      expect {
        fill_in 'admin_invitation_email', with: "newinvite@example.com"
        click_link_or_button "Send Invitation"
      }.to change(Admin::User, :count).by(1)
        .and change(Admin::Invitation, :count).by(1)

      invited_user = Admin::User.find_by(email: "newinvite@example.com")
      expect(invited_user.status).to eq("invited")

      invitation = Admin::Invitation.find_by(email: "newinvite@example.com")
      expect(invitation.status).to eq("pending")
      expect(invitation.admin_user).to eq(invited_user)
    end

    it "does not create invitation when email is blank" do
      click_link_or_button "Settings"

      expect {
        click_link_or_button "Send Invitation"
      }.not_to change(Admin::User, :count)

      expect(page).to have_current_path(admin_settings_team_path)
    end
  end

  context "when admin is signed in and duplicate invitation exists" do
    let!(:admin) { create(:admin_user) }
    let!(:existing_user) { Admin::User.create!(email: "duplicate@example.com", status: :invited) }
    let!(:existing_invitation) do
      Admin::Invitation.create!(
        email: "duplicate@example.com",
        invited_by: admin,
        admin_user: existing_user
      )
    end

    before do
      sign_in admin, scope: :admin_user
      visit admin_settings_team_path
    end

    it "does not create duplicate invitation for same email" do
      expect {
        fill_in 'admin_invitation_email', with: "duplicate@example.com"
        click_link_or_button "Send Invitation"
      }.not_to change(Admin::Invitation, :count)

      expect(page).to have_current_path(admin_settings_team_path)
      expect(Admin::User.where(email: "duplicate@example.com").count).to eq(1)
    end
  end

  context "when pending invitation exists" do
    let!(:admin) { create(:admin_user) }
    let!(:invitation) do
      Admin::Invitation.create!(
        email: "newadmin@example.com",
        invited_by: admin,
        admin_user: Admin::User.create!(email: "newadmin@example.com", status: :invited)
      )
    end

    it "allows invited user to set password and activate account" do
      visit admin_invitation_path(invitation.token)

      expect(page).to have_content("Admin Invitation")
      expect(page).to have_content(admin.email)
      expect(page).to have_content("newadmin@example.com")

      fill_in "admin_user_password", with: "newpassword123"
      fill_in "admin_user_password_confirmation", with: "newpassword123"
      click_link_or_button "Accept Invitation & Activate Account"

      expect(page).to have_content("Welcome! Your admin account has been activated.")
      expect(page).to have_current_path(admin_root_path)

      invitation.reload
      expect(invitation.status).to eq("accepted")
      expect(invitation.admin_user.status).to eq("active")
    end
  end

  context "when expired invitation exists" do
    let!(:admin) { create(:admin_user) }
    let!(:expired_user) { Admin::User.create!(email: "expired@example.com", status: :invited) }
    let!(:invitation) do
      Admin::Invitation.create!(
        email: "expired@example.com",
        invited_by: admin,
        admin_user: expired_user,
        expires_at: 1.day.ago
      )
    end

    it "displays expiration message for expired invitation" do
      visit admin_invitation_path(invitation.token)

      expect(page).to have_content("This invitation has expired")
      expect(page).not_to have_content("Set Your Password")
    end
  end

  context "when accepted invitation exists" do
    let!(:admin) { create(:admin_user) }
    let!(:accepted_user) do
      Admin::User.create!(
        email: "accepted@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: :active
      )
    end
    let!(:invitation) do
      Admin::Invitation.create!(
        email: "accepted@example.com",
        invited_by: admin,
        admin_user: accepted_user,
        status: "accepted",
        accepted_at: 1.day.ago
      )
    end

    it "displays acceptance message for already accepted invitation" do
      visit admin_invitation_path(invitation.token)

      expect(page).to have_content("This invitation has already been accepted")
      expect(page).to have_link("Go to Admin Login")
    end
  end

  context "when admin is signed in and team member exists to delete" do
    let!(:admin_to_delete) { create(:admin_user, email: "delete@example.com") }

    before do
      Admin::User.where.not(id: admin_to_delete.id).destroy_all
      login_as_admin
    end

    it "deletes admin user from team" do
      click_link_or_button "Settings"

      # Find the row containing the admin's email and click its delete button
      expect {
        within("tr", text: admin_to_delete.email) do
          accept_confirm do
            find("button[data-turbo-confirm]").trigger("click")
          end
        end
      }.to change(Admin::User, :count).by(-1)

      # After deletion, redirects to admin_teams_path (old route still used by delete button)
      expect(page).to have_current_path(admin_teams_path)
      expect(page).not_to have_content(admin_to_delete.email)
    end
  end

  context "when admin is signed in" do
    before do
      login_as_admin
    end

    it "displays the company information page" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      expect(page).to have_content("Company Information")
      expect(page).to have_content("Company Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Phone Number")
      expect(page).to have_content("Address")
      expect(page).to have_content("Full Address")
      expect(page).to have_current_path(admin_settings_company_path)
    end

    it "allows accessing edit modals without errors" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Click Edit button for company name
      first("button", text: "Edit").trigger("click")
      expect(page).to have_text("Edit Company Name")

      # Cancel the modal
      within "#company_name_modal" do
        click_button "Cancel"
      end

      # Click Edit button for contact info
      all("button", text: "Edit")[1].trigger("click")
      expect(page).to have_text("Edit Contact Information")
    end

    it "opens company name edit modal" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Click first Edit button (Company Name)
      first("button", text: "Edit").trigger("click")

      expect(page).to have_text("Edit Company Name")
      expect(page).to have_selector("input#company_name")
    end

    it "allows canceling edit via modal" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Click first Edit button
      first("button", text: "Edit").trigger("click")

      expect(page).to have_text("Edit Company Name")

      # Click Cancel button in modal
      within "#company_name_modal" do
        click_button "Cancel"
      end

      # Modal should close, back to main page
      expect(page).to have_content("Company Information")
    end
  end

  context "when admin is signed in and company exists" do
    let!(:company) { create(:company) }

    before do
      login_as_admin
    end

    it "displays existing company data" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.email)
      expect(page).to have_content(company.phone_number)
    end

    it "successfully saves company name changes" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Edit company name
      first("button", text: "Edit").trigger("click")

      within "#company_name_modal" do
        fill_in "company_name", with: "New Company Name"
        click_button "Save"
      end

      expect(page).to have_content("New Company Name")
      expect(page).to have_current_path(admin_settings_company_path)
    end

    it "opens contact info edit modal" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Click Edit button for contact info (2nd Edit button)
      all("button", text: "Edit")[1].trigger("click")

      expect(page).to have_text("Edit Contact Information")
      expect(page).to have_selector("input#company_email")
      expect(page).to have_selector("input#company_phone_number")
    end
  end
end
