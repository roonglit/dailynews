require 'rails_helper'

describe "Admin Can Edit Company Contact Info" do
  before { login_as_admin }

  it "allows accessing edit modals without errors" do
    visit admin_root_path
    click_link "Settings"
    click_link "Company Info"

    # Click Edit button for company name
    first("button", text: "Edit").click
    expect(page).to have_text("Edit Company Name")

    # Cancel the modal
    within "#company_name_modal" do
      click_button "Cancel"
    end

    # Click Edit button for contact info
    all("button", text: "Edit")[1].click
    expect(page).to have_text("Edit Contact Information")
  end

  context "when company exists" do
    let!(:company) { create(:company) }

    it "opens contact info edit modal" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Click Edit button for contact info (2nd Edit button)
      all("button", text: "Edit")[1].click

      expect(page).to have_text("Edit Contact Information")
      expect(page).to have_selector("input#company_email")
      expect(page).to have_selector("input#company_phone_number")
    end
  end
end
