require 'rails_helper'

describe "Invited Admin Can Accept Invitation" do
  it "allows invited user to set password and activate account" do
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
end
