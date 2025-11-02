require 'rails_helper'

describe "Admin Can View Customer Details" do
  it "navigates to customer information page" do
    subscription = create(:subscription)
    customer = subscription.member

    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Purchase History")
  end
end
