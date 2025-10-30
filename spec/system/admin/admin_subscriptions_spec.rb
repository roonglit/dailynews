require 'rails_helper'

describe "Admin Subscriptions" do
  it "displays all subscriptions" do
    subscription = create(:subscription)
    login_as_admin

    click_link_or_button "Subscriptions"

    expect(page).to have_current_path(admin_subscriptions_path)
    expect(page).to have_link("Subscriptions")
    expect(page).to have_content(subscription.member.email)
  end

  it "navigates to customer information page when viewing customer" do
    subscription = create(:subscription)
    login_as_admin

    click_link_or_button "Subscriptions"
    click_link_or_button "View Customer"

    expect(page).to have_current_path(admin_customer_path(subscription.member))
    expect(page).to have_content("Basic Information")
  end

  it "shows no subscriptions when none exist" do
    login_as_admin

    click_link_or_button "Subscriptions"

    expect(page).to have_current_path(admin_subscriptions_path)
    expect(page).to have_link("Subscriptions")
    expect(page).not_to have_selector("tbody tr")
  end
end
