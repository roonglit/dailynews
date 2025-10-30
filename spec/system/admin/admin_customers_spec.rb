require 'rails_helper'

describe "Admin Customers" do
  context "navigate to customer page" do
    before { @subscriptions = create_list(:subscription, 1) }

    it "when admin press customers should navigate to customers path correctly" do
      login_as_admin

      click_link_or_button "Customers"

      expect(page).to have_current_path(admin_customers_path)
      expect(page).to have_content("Customers")
      expect(page).to have_content("test1@example.com")
    end
  end

  context "navigate to edit infomation page" do
    before { @subscriptions = create_list(:subscription, 1) }

    it "when admin press edit should navigate to edit Information page" do
      login_as_admin

      click_link_or_button "Customers"
      find('.edit-icon').click

      expect(page).to have_current_path(edit_admin_customer_path(1))
      expect(page).to have_content("Basic Information")
    end

    it "when admin press back from edit customer info page should navigate to edit Information page" do
      login_as_admin

      click_link_or_button "Customers"
      find('.edit-icon').click
      fill_in 'member_first_name', with: "firstname"
      fill_in 'member_last_name', with: "lastname"
      click_link_or_button "Back"

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Purchase History")
      expect(page).to have_content("-")
    end

    it "when admin press cancel from edit customer info page should navigate to edit Information page" do
      login_as_admin

      click_link_or_button "Customers"
      find('.edit-icon').click
      fill_in 'member_first_name', with: "firstname"
      fill_in 'member_last_name', with: "lastname"
      click_link_or_button "Cancel"

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Purchase History")
      expect(page).to have_content("-")
    end

    it "when admin press save with empty full name from edit customer info page should navigate to edit Information page with empty full name" do
      login_as_admin

      click_link_or_button "Customers"
      find('.edit-icon').click
      click_link_or_button "Save"

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Purchase History")
      expect(page).to have_content("-")
    end

    it "when admin press save with empty full name from edit customer info page should navigate to edit Information page with empty full name" do
      login_as_admin

      click_link_or_button "Customers"
      find('.edit-icon').click
      fill_in 'member_first_name', with: "firstname"
      fill_in 'member_last_name', with: "lastname"
      click_link_or_button "Save"

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Purchase History")
      expect(page).to have_content("firstname lastname")
    end
  end

  context "navigate to customer page" do
    before { @subscriptions = create_list(:subscription, 1) }

    it "navigate to infomation page" do
      login_as_admin

      click_link_or_button "Customers"
      find('.show-icon').click

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Purchase History")
    end

    it "when admin press edit should navigate to infomation page correctly" do
      login_as_admin

      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Edit"

      expect(page).to have_current_path(edit_admin_customer_path(1))
    end

    it "when admin press create subscription should navigate to create subscription page correctly" do
      login_as_admin

      click_link_or_button "Customers"
      find('.show-icon').click
      click_link_or_button "Create Subscription"

      expect(page).to have_current_path(new_admin_customer_subscription_path(1))
      expect(page).to have_content("Subscription Details")
    end

    it "when press cancel on create subscription page should navigate back to create subscription page correctly" do
      login_as_admin

      expect {
        click_link_or_button "Customers"
        find('.show-icon').click
        click_link_or_button "Create Subscription"
        click_link_or_button "Cancel"
      }.not_to change(Subscription, :count)

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Basic Information")
    end

    it "given field date correctly when press save on create subscription page should navigate back to create subscription page correctly" do
      login_as_admin

      expect {
        click_link_or_button "Customers"
        find('.show-icon').click
        click_link_or_button "Create Subscription"
        find("[data-testid='start_date_picker']").set("2025-10-30")
        find("[data-testid='end_date_picker']").set("2025-11-30")
        click_link_or_button "Save"
      }.to change(Subscription, :count).from(1).to(2)

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Basic Information")
    end

    it "given field date incorrect when press save on create subscription page should stay on same page" do
      login_as_admin

      expect {
        click_link_or_button "Customers"
        find('.show-icon').click
        click_link_or_button "Create Subscription"
        find("[data-testid='start_date_picker']").set("yyyy-mm-dd")
        find("[data-testid='end_date_picker']").set("yyyy-mm-dd")
        click_link_or_button "Save"
      }.not_to change(Subscription, :count)

      expect(page).to have_current_path(new_admin_customer_subscription_path(1))
      expect(page).to have_content("2 errors prohibited this subscription from being saved:")
      expect(page).to have_content("Start date Can't be blank")
      expect(page).to have_content("End date Can't be blank")
    end

    it "given do not field date when press save on create subscription page should fill field and navigate back to create subscription page correctly" do
      login_as_admin

      expect {
        click_link_or_button "Customers"
        find('.show-icon').click
        click_link_or_button "Create Subscription"
        click_link_or_button "Save"
      }.to change(Subscription, :count).from(1).to(2)

      expect(page).to have_current_path(admin_customer_path(1))
      expect(page).to have_content("Basic Information")
    end
  end
end
