require 'rails_helper'

describe "Admin Can Delete Team Member" do
  it "deletes admin user from team" do
    Admin::User.destroy_all
    admin_to_delete = create(:admin_user, email: "delete@example.com")
    login_as_admin

    click_link_or_button "Settings"

    # Find the row containing the admin's email and click its delete button
    expect {
      within("tr", text: admin_to_delete.email) do
        accept_confirm do
          find("button[data-turbo-confirm]").click
        end
      end
    }.to change(Admin::User, :count).by(-1)

    # After deletion, redirects to admin_teams_path (old route still used by delete button)
    expect(page).to have_current_path(admin_teams_path)
    expect(page).not_to have_content(admin_to_delete.email)
  end
end
