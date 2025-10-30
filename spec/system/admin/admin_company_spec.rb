require 'rails_helper'

describe "Admin Company" do
  before { login_as_admin }

  it "displays the company information page" do
    visit admin_root_path
    click_link "Company Info"

    expect(page).to have_content("Basic Information")
    expect(page).to have_content("Company Name")
    expect(page).to have_content("Address Line 1")
    expect(page).to have_content("Address Line 2")
    expect(page).to have_content("Sub district")
    expect(page).to have_content("District")
    expect(page).to have_content("Province")
    expect(page).to have_content("Country")
    expect(page).to have_content("Postal Code")
    expect(page).to have_content("Email")
    expect(page).to have_content("Phone Number")
    expect(page).to have_current_path(admin_company_path)
  end

  it "navigates to create form when company does not exist" do
    visit admin_root_path
    click_link "Company Info"

    expect(page).to have_content("Create")
    click_link "Create"

    expect(page).to have_text("Company")
    expect(page).to have_text("New")
  end

  it "allows canceling company creation" do
    visit admin_root_path
    click_link "Company Info"
    click_link "Create"

    expect(page).to have_current_path(new_admin_company_path)

    click_link "Cancel"

    expect(page).to have_current_path(admin_company_path)
  end

  it "shows validation errors when saving without required fields" do
    visit admin_root_path
    click_link "Company Info"
    click_link "Create"

    expect(page).to have_current_path(new_admin_company_path)

    click_button "Save"

    expect(page).to have_text("Name Can't be blank")
    expect(page).to have_text("Address 1 Can't be blank")
    expect(page).to have_text("Sub district Can't be blank")
    expect(page).to have_text("District Can't be blank")
    expect(page).to have_text("Province Can't be blank")
    expect(page).to have_text("Postal code Can't be blank")
    expect(page).to have_text("Country Can't be blank")
    expect(page).to have_text("Phone number Can't be blank")
    expect(page).to have_text("Email Can't be blank")
    expect(page).to have_current_path(new_admin_company_path)
  end

  context "when company exists" do
    let!(:company) { create(:company) }

    it "navigates to edit form" do
      visit admin_root_path
      click_link "Company Info"

      expect(page).to have_content("Edit")
      click_link "Edit"

      expect(page).to have_text("Company")
      expect(page).to have_text("Edit")
    end

    it "allows canceling company edit" do
      visit admin_root_path
      click_link "Company Info"
      click_link "Edit"

      expect(page).to have_current_path(edit_admin_company_path)

      click_link "Cancel"

      expect(page).to have_current_path(admin_company_path)
    end

    it "successfully saves company changes" do
      visit admin_root_path
      click_link "Company Info"
      click_link "Edit"

      expect(page).to have_current_path(edit_admin_company_path)

      click_button "Save"

      expect(page).to have_current_path(admin_company_path)
    end
  end
end
