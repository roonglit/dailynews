require 'rails_helper'

describe "Admin Can Navigate From Subscription To Customer" do
  it "navigates to customer information page when viewing customer" do
    subscription = create(:subscription)
    login_as_admin

    click_link_or_button "Subscriptions"
    click_link_or_button "View Customer"

    expect(page).to have_current_path(admin_customer_path(subscription.member))
    expect(page).to have_content("Basic Information")
  end
end
