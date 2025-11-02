require 'rails_helper'

describe "Admin Can View Subscriptions List" do
  it "displays all subscriptions" do
    subscription = create(:subscription)
    login_as_admin

    click_link_or_button "Subscriptions"

    expect(page).to have_current_path(admin_subscriptions_path)
    expect(page).to have_link("Subscriptions")
    expect(page).to have_content(subscription.member.email)
  end

  it "shows empty list when no subscriptions exist" do
    login_as_admin

    click_link_or_button "Subscriptions"

    expect(page).to have_current_path(admin_subscriptions_path)
    expect(page).to have_link("Subscriptions")
    expect(page).not_to have_selector("tbody tr")
  end
end
