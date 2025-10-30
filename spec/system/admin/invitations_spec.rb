require 'rails_helper'

describe "Admin Invitations" do
  it "shows an error message when email is blank" do
    login_as_admin

    click_link_or_button "Admin Teams"
    click_link_or_button "Invite Team Members"
    click_link_or_button "Send Invite"

    expect(page).to have_current_path(new_admin_team_path)
    expect(page).to have_content("Email can't be blank")
    expect(page).not_to have_content("Invitation sent successfully.")
  end

  it "shows a success message with valid email" do
    login_as_admin

    click_link_or_button "Admin Teams"
    click_link_or_button "Invite Team Members"

    fill_in 'invite_email', with: "admin10@hotmail.com"
    click_link_or_button "Send Invite"

    expect(page).to have_current_path(new_admin_team_path)
    expect(page).not_to have_content("Email can't be blank")
    expect(page).to have_content("Invitation sent successfully.")
  end

  it "creates an Admin::User with invited status and an AdminInvitation record" do
    login_as_admin

    click_link_or_button "Admin Teams"
    click_link_or_button "Invite Team Members"

    expect {
      fill_in 'invite_email', with: "newinvite@example.com"
      click_link_or_button "Send Invite"
    }.to change(Admin::User, :count).by(1)
      .and change(AdminInvitation, :count).by(1)

    invited_user = Admin::User.find_by(email: "newinvite@example.com")
    expect(invited_user.status).to eq("invited")

    invitation = AdminInvitation.find_by(email: "newinvite@example.com")
    expect(invitation.status).to eq("pending")
    expect(invitation.admin_user).to eq(invited_user)
  end

  it "prevents duplicate invitations for the same email" do
    admin = create(:admin_user)
    AdminInvitation.create!(
      email: "duplicate@example.com",
      invited_by: admin,
      admin_user: Admin::User.create!(email: "duplicate@example.com", status: :invited)
    )

    sign_in admin, scope: :admin_user
    visit new_admin_team_path

    fill_in 'invite_email', with: "duplicate@example.com"
    click_link_or_button "Send Invite"

    expect(page).to have_content("There is already a pending invitation for this email")
  end

  it "allows the invited user to set their password and activate their account" do
    admin = create(:admin_user)
    invitation = AdminInvitation.create!(
      email: "newadmin@example.com",
      invited_by: admin,
      admin_user: Admin::User.create!(email: "newadmin@example.com", status: :invited)
    )

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

  it "displays an expiration message for expired invitations" do
    admin = create(:admin_user)
    expired_user = Admin::User.create!(email: "expired@example.com", status: :invited)
    invitation = AdminInvitation.create!(
      email: "expired@example.com",
      invited_by: admin,
      admin_user: expired_user,
      expires_at: 1.day.ago
    )

    visit admin_invitation_path(invitation.token)

    expect(page).to have_content("This invitation has expired")
    expect(page).not_to have_content("Set Your Password")
  end

  it "displays an acceptance message for already accepted invitations" do
    admin = create(:admin_user)
    accepted_user = Admin::User.create!(
      email: "accepted@example.com",
      password: "password123",
      password_confirmation: "password123",
      status: :active
    )
    invitation = AdminInvitation.create!(
      email: "accepted@example.com",
      invited_by: admin,
      admin_user: accepted_user,
      status: "accepted",
      accepted_at: 1.day.ago
    )

    visit admin_invitation_path(invitation.token)

    expect(page).to have_content("This invitation has already been accepted")
    expect(page).to have_link("Go to Admin Login")
  end
end
