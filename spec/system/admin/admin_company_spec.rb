require 'rails_helper'

describe "Admin Customers" do
    before do
        login_as_admin
    end

    it "can show admin company page" do
        # Visit admin page
        visit "/admin"

        # Click Company Info
        click_link "Company Info"

        # Should see company content
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

        # Should stay on admin_company path
        expect(page).to have_current_path("/admin/company")
    end

    context "company no data" do
        it "can click create button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Should see edit button
            expect(page).to have_content("Create")

            # Can click edit button
            click_link "Create"

            # Should see breadcrumb company > Edit button
            expect(page).to have_text("Company")
            expect(page).to have_text("New")
        end

        it "can click cancel button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Should see edit button
            expect(page).to have_content("Create")

            # Can click edit button
            click_link "Create"

            # Should stay on edit page
            expect(page).to have_current_path("/admin/company/new")

            # Can click cancel button
            click_link "Cancel"

            # Should redirect to company info page
            expect(page).to have_current_path("/admin/company")
        end

        it "can click save button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Can click create button
            click_link "Create"

            # Should stay on create page
            expect(page).to have_current_path("/admin/company/new")

            # Can click save button
            click_button "Save"

            # Should show error cannot saved
            expect(page).to have_text("Name Can't be blank")
            expect(page).to have_text("Address 1 Can't be blank")
            expect(page).to have_text("Sub district Can't be blank")
            expect(page).to have_text("District Can't be blank")
            expect(page).to have_text("Province Can't be blank")
            expect(page).to have_text("Postal code Can't be blank")
            expect(page).to have_text("Country Can't be blank")
            expect(page).to have_text("Phone number Can't be blank")
            expect(page).to have_text("Email Can't be blank")

            # Should stay on create page
            expect(page).to have_current_path("/admin/company/new")
        end
    end

    context "company have data" do
        let!(:company) { create(:company) }

        it "can click edit button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Should see edit button
            expect(page).to have_content("Edit")

            # Can click edit button
            click_link "Edit"

            # Should see breadcrumb company > Edit button
            expect(page).to have_text("Company")
            expect(page).to have_text("Edit")
        end

        it "can click cancel button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Should see edit button
            expect(page).to have_content("Edit")

            # Can click edit button
            click_link "Edit"

            # Should stay on edit page
            expect(page).to have_current_path("/admin/company/edit")

            # Can click cancel button
            click_link "Cancel"

            # Should redirect to company info page
            expect(page).to have_current_path("/admin/company")
        end

        it "can click save button" do
            # Visit admin page
            visit "/admin"

            # Click Company Info
            click_link "Company Info"

            # Can click edit button
            click_link "Edit"

            # Should stay on edit page
            expect(page).to have_current_path("/admin/company/edit")

            # Can click cancel button
            click_button "Save"

            # Should redirect to company info page
            expect(page).to have_current_path("/admin/company")
        end
    end
end
