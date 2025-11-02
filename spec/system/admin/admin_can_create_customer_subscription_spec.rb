require 'rails_helper'

describe "Admin Can Create Customer Subscription" do
  before { @subscription = create(:subscription) }
  let(:customer) { @subscription.member }

  it "navigates to create subscription page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Create Subscription"

    expect(page).to have_current_path(new_admin_customer_subscription_path(customer))
    expect(page).to have_content("Subscription Details")
  end

  it "creates a subscription with valid dates" do
    login_as_admin

    expect {
      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Create Subscription"
      find("[data-testid='start_date_picker']").set("2025-10-30")
      find("[data-testid='end_date_picker']").set("2025-11-30")
      click_link_or_button "Save"
    }.to change(Subscription, :count).from(1).to(2)

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Basic Information")
  end

  it "creates a subscription without providing dates" do
    login_as_admin

    expect {
      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Create Subscription"
      click_link_or_button "Save"
    }.to change(Subscription, :count).from(1).to(2)

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Basic Information")
  end
end
