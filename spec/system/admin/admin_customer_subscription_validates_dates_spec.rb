require 'rails_helper'

describe "Admin Customer Subscription Validates Dates" do
  it "shows validation errors with invalid dates" do
    subscription = create(:subscription)
    customer = subscription.member

    login_as_admin

    expect {
      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Create Subscription"
      find("[data-testid='start_date_picker']").set("yyyy-mm-dd")
      find("[data-testid='end_date_picker']").set("yyyy-mm-dd")
      click_link_or_button "Save"
    }.not_to change(Subscription, :count)

    expect(page).to have_current_path(new_admin_customer_subscription_path(customer))
    expect(page).to have_content("2 errors prohibited this subscription from being saved:")
    expect(page).to have_content("Start date Can't be blank")
    expect(page).to have_content("End date Can't be blank")
  end
end
