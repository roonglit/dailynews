require 'rails_helper'

describe "Admin Can View Customers List" do
  it "navigates to customers page and displays customers" do
    subscription = create(:subscription)
    customer = subscription.member

    login_as_admin
    click_link_or_button "Customers"

    expect(page).to have_current_path(admin_customers_path)
    expect(page).to have_content("Customers")
    expect(page).to have_content(customer.email)
  end
end
