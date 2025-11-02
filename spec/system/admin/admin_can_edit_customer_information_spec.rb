require 'rails_helper'

describe "Admin Can Edit Customer Information" do
  before { @subscription = create(:subscription) }
  let(:customer) { @subscription.member }

  it "navigates to edit customer information page from list" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click

    expect(page).to have_current_path(edit_admin_customer_path(customer))
    expect(page).to have_content("Basic Information")
  end

  it "navigates to edit from customer information page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Edit"

    expect(page).to have_current_path(edit_admin_customer_path(customer))
    expect(page).to have_content("Customer")
  end

  it "saves customer information without name changes" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click
    click_link_or_button "Save"

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Purchase History")
    expect(page).to have_content("-")
  end

  it "saves customer information with name updates" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click
    fill_in 'member_first_name', with: "firstname"
    fill_in 'member_last_name', with: "lastname"
    click_link_or_button "Save"

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Purchase History")
    expect(page).to have_content("firstname lastname")
  end
end
