require 'rails_helper'

describe "Admin Can View Company Information" do
  before { login_as_admin }

  it "displays the company information page" do
    visit admin_root_path
    click_link "Settings"
    click_link "Company Info"

    expect(page).to have_content("Company Information")
    expect(page).to have_content("Company Name")
    expect(page).to have_content("Email")
    expect(page).to have_content("Phone Number")
    expect(page).to have_content("Address")
    expect(page).to have_content("Full Address")
    expect(page).to have_current_path(admin_settings_company_path)
  end

  context "when company exists" do
    let!(:company) { create(:company) }

    it "displays existing company data" do
      visit admin_root_path
      click_link "Settings"
      click_link "Company Info"

      expect(page).to have_content(company.name)
      expect(page).to have_content(company.email)
      expect(page).to have_content(company.phone_number)
    end
  end
end
