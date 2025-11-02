require 'rails_helper'

describe "Admin Can Cancel Editing Customer" do
  before { @subscription = create(:subscription) }
  let(:customer) { @subscription.member }

  it "navigates back from edit page when user clicks edit icon" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click
    fill_in 'member_first_name', with: "firstname"
    fill_in 'member_last_name', with: "lastname"
    click_link_or_button "Back"

    expect(page).to have_current_path(admin_customers_path)
    expect(page).to have_content("Customer")
  end

  it "cancels editing customer information when user clicks edit icon" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click
    fill_in 'member_first_name', with: "firstname"
    fill_in 'member_last_name', with: "lastname"
    click_link_or_button "Cancel"

    expect(page).to have_current_path(admin_customers_path)
    expect(page).to have_content("Customer")
  end

  it "navigates back from edit page when user clicks show icon and edit customer" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Edit"

    click_link_or_button "Back"

    expect(page).to have_current_path(admin_customer_path(customer))
  end
end
