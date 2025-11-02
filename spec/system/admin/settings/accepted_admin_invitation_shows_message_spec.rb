require 'rails_helper'

describe "Accepted Admin Invitation Shows Message" do
  it "displays acceptance message for already accepted invitation" do
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
