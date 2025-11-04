require 'rails_helper'

describe "Admin Teams" do
  it "displays all admin team members" do
    admins = create_list(:admin_user, 5)
    login_as_admin

    click_link_or_button "Settings"

    expect(page).to have_content("6 admin users")
    expect(page).to have_content(admins.first.email)
  end

  it "shows the invitation form" do
    login_as_admin

    click_link_or_button "Settings"

    expect(page).to have_content("Invite Admin User")
    expect(page).to have_content("Send an invitation email to add a new admin user to your team.")
  end

  it "admin can delete admin user" do
    Admin::User.destroy_all
    admin = create(:admin_user)
    login_as_admin(admin)

    fake_admin = create(:admin_user)

    click_link_or_button "Settings"

    accept_confirm do
      find(".trash-icon-#{fake_admin.id}").trigger("click")
    end

    expect(page).not_to have_content(fake_admin.email)
  end
end
