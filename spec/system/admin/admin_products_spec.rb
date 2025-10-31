require 'rails_helper'

describe "Manage Admin Products" do
  context "given an admin user with existing products" do
    it "when admin press Products button then navigate to mange products correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar
      click_link_or_button "Products"

      # system navigate to products page correctly
      expect(page).to have_current_path(admin_products_path)

      # system show page title correctly
      expect(page).to have_content("Products")
    end
  end

  context "given an admin user press show product detail with existing products" do
    before { @products = create_list(:product, 1) }
    it "when admin press show Products button then navigate to products detail correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar then press show button
      expect {
        click_link_or_button "Products"
        find('.show-icon').click
      }.not_to change(Product, :count)

      # system navigate to show products page correctly
      expect(page).to have_current_path(admin_product_path(1))

      # system show page title correctly
      expect(page).to have_content("Product Details")
    end

    it "when admin press back on product detail page button then navigate back to products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar, press show then press back button
      expect {
        click_link_or_button "Products"
        find('.show-icon').click
        click_link_or_button "Back to list"
      }.not_to change(Product, :count)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(admin_products_path)

      # system show page title correctly
      expect(page).to have_content("Products")
    end

    it "when admin press edit Products on product detail page button then navigate to edit products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar, press show then press edit button
      expect {
        click_link_or_button "Products"
        find('.show-icon').click
        click_link_or_button "Edit"
      }.not_to change(Product, :count)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(edit_admin_product_path(1))

      # system show page title correctly
      expect(page).to have_content("Edit Product")
    end

    it "when admin press delete Products on product detail page button then navigate to products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar, press show then press delete button
      expect {
        click_link_or_button "Products"
        find('.show-icon').click
        click_link_or_button "Delete"
      }.to change(Product, :count).from(1).to(0)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(admin_products_path)

      # system show page title correctly
      expect(page).to have_content("Products")
    end
  end

  context "given an admin user press edit product detail with existing products" do
    before { @products = create_list(:product, 1) }
    it "when admin press edit Products button then navigate to edit products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar then press show button
      expect {
        click_link_or_button "Products"
        find('.edit-icon').click
      }.not_to change(Product, :count)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(edit_admin_product_path(1))

      # system show page title correctly
      expect(page).to have_content("Edit Product")
    end

    it "when admin press edit Products button then navigate to edit products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar then press show button
      expect {
        click_link_or_button "Products"
        find('.edit-icon').click
        click_link_or_button "Cancel"
      }.not_to change(Product, :count)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(admin_product_path(1))

      # system show page title correctly
      expect(page).to have_content("Product Details")
    end

    it "when admin press edit Products button then navigate to edit products page correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar then press show button
      expect {
        click_link_or_button "Products"
        find('.edit-icon').click
        click_link_or_button "Save"
      }.not_to change(Product, :count)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(admin_product_path(1))

      # system show page title correctly
      expect(page).to have_content("Product Details")
    end
  end

  context "given an admin user press delete product detail with existing products" do
    before { @products = create_list(:product, 1) }
    it "when admin press delete Products button then delete products correctly" do
      # login with admin account
      login_as_admin

      # admin press Products on side bar then press show button
      expect {
        click_link_or_button "Products"
        find('.trash-icon').click
      }.to change(Product, :count).from(1).to(0)

      # system navigate to edit products page correctly
      expect(page).to have_current_path(admin_products_path)

      # system show page title correctly
      expect(page).to have_content("Products")
    end
  end
end
