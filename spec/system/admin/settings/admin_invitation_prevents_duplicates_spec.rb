require 'rails_helper'

describe "Admin Invitation Prevents Duplicates" do
  it "does not create duplicate invitation for same email" do
    admin = create(:admin_user)
    existing_user = Admin::User.create!(email: "duplicate@example.com", status: :invited)
    AdminInvitation.create!(
      email: "duplicate@example.com",
      invited_by: admin,
      admin_user: existing_user
    )

    sign_in admin, scope: :admin_user
    visit admin_settings_team_path

    expect {
      fill_in 'invite_email', with: "duplicate@example.com"
      click_link_or_button "Send Invitation"
    }.not_to change(AdminInvitation, :count)

    expect(page).to have_current_path(admin_settings_team_path)
    expect(Admin::User.where(email: "duplicate@example.com").count).to eq(1)
  end
end
