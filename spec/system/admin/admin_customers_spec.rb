require 'rails_helper'

describe "Admin Customers" do
  before { @subscription = create(:subscription) }

  let(:customer) { @subscription.member }

  it "navigates to customers page" do
    login_as_admin
    click_link_or_button "Customers"

    expect(page).to have_current_path(admin_customers_path)
    expect(page).to have_content("Customers")
    expect(page).to have_content(customer.email)
  end

  it "navigates to edit customer information page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.edit-icon').click

    expect(page).to have_current_path(edit_admin_customer_path(customer))
    expect(page).to have_content("Basic Information")
  end

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

  it "navigates to customer information page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click

    expect(page).to have_current_path(admin_customer_path(customer))
    expect(page).to have_content("Purchase History")
  end

  it "navigates to edit from customer information page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Edit"

    expect(page).to have_current_path(edit_admin_customer_path(customer))
    expect(page).to have_content("Customer")
  end

  it "cancels editing customer information when user clicks edit icon" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Edit"

    expect(page).to have_current_path(edit_admin_customer_path(customer))
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

  it "navigates to create subscription page" do
    login_as_admin
    click_link_or_button "Customers"
    find('.show-icon').click
    click_link_or_button "Create Subscription"

    expect(page).to have_current_path(new_admin_customer_subscription_path(customer))
    expect(page).to have_content("Subscription Details")
  end

  it "cancels creating a subscription" do
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

  it "shows validation errors with invalid dates" do
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
