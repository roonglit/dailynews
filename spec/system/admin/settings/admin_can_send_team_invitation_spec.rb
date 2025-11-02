require 'rails_helper'

describe "Admin Can Send Team Invitation" do
  it "creates invitation with valid email" do
    login_as_admin

    click_link_or_button "Settings"

    expect {
      fill_in 'invite_email', with: "admin10@hotmail.com"
      click_link_or_button "Send Invitation"
    }.to change(Admin::User, :count).by(1)

    expect(page).to have_current_path(admin_settings_team_path)
    expect(page).to have_content("admin10@hotmail.com")
  end

  it "creates Admin::User with invited status and AdminInvitation record" do
    login_as_admin

    click_link_or_button "Settings"

    expect {
      fill_in 'invite_email', with: "newinvite@example.com"
      click_link_or_button "Send Invitation"
    }.to change(Admin::User, :count).by(1)
      .and change(AdminInvitation, :count).by(1)

    invited_user = Admin::User.find_by(email: "newinvite@example.com")
    expect(invited_user.status).to eq("invited")

    invitation = AdminInvitation.find_by(email: "newinvite@example.com")
    expect(invitation.status).to eq("pending")
    expect(invitation.admin_user).to eq(invited_user)
  end
end
