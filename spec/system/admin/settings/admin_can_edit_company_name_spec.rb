require 'rails_helper'

describe "Admin Can Edit Company Name" do
  before { login_as_admin }

  it "opens company name edit modal" do
    visit admin_root_path
    click_link "Settings"
    click_link "Company Info"

    # Click first Edit button (Company Name)
    first("button", text: "Edit").click

    expect(page).to have_text("Edit Company Name")
    expect(page).to have_selector("input#company_name")
  end

  it "allows canceling edit via modal" do
    visit admin_root_path
    click_link "Settings"
    click_link "Company Info"

    # Click first Edit button
    first("button", text: "Edit").click

    expect(page).to have_text("Edit Company Name")

    # Click Cancel button in modal
    within "#company_name_modal" do
      click_button "Cancel"
    end

    # Modal should close, back to main page
    expect(page).to have_content("Company Information")
  end

  context "when company exists" do
    let!(:company) { create(:company) }

    it "successfully saves company name changes" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      # Edit company name
      first("button", text: "Edit").click

      within "#company_name_modal" do
        fill_in "company_name", with: "New Company Name"
        click_button "Save"
      end

      expect(page).to have_content("New Company Name")
      expect(page).to have_current_path(admin_settings_company_path)
    end
  end
end
