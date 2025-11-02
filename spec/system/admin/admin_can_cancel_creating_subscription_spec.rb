require 'rails_helper'

describe "Admin Can Cancel Creating Subscription" do
  it "cancels creating a subscription" do
    subscription = create(:subscription)
    customer = subscription.member

    login_as_admin

    expect {
      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Create Subscription"
      click_link_or_button "Cancel"
    }.not_to change(Subscription, :count)

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Basic Information")
  end
end
