require 'rails_helper'

describe "Expired Admin Invitation Shows Message" do
  it "displays expiration message for expired invitation" do
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
end
