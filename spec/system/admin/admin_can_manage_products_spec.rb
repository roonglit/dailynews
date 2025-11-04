require 'rails_helper'

describe "Admin can manage products", js: true do
  context "when admin is signed in" do
    before do
      login_as_admin
    end

    it "navigates to products page" do
      click_link_or_button "Products"

      expect(page).to have_current_path(admin_products_path)
      expect(page).to have_content("Products")
    end
  end

  context "when admin is signed in and product exists" do
    before do
      create_list(:product, 1)
      login_as_admin
    end

    it "navigates to product detail page" do
      expect {
        click_link_or_button "Products"
        find('.show-icon').trigger("click")
      }.not_to change(Product, :count)

      expect(page).to have_current_path(admin_product_path(1))
      expect(page).to have_content("Product Details")
    end

    it "navigates back from product detail page" do
      expect {
        click_link_or_button "Products"
        find('.show-icon').trigger("click")
        click_link_or_button "Back to list"
      }.not_to change(Product, :count)

      expect(page).to have_current_path(admin_products_path)
      expect(page).to have_content("Products")
    end
  end

  context "when admin is signed in and product exists for editing" do
    before do
      @products = create_list(:product, 1)
      login_as_admin
    end

    it "navigates to edit product from detail page" do
      expect {
        click_link_or_button "Products"
        find('.show-icon').trigger("click")
        click_link_or_button "Edit"
      }.not_to change(Product, :count)

      expect(page).to have_current_path(edit_admin_product_path(1))
      expect(page).to have_content("Edit Product")
    end

    it "navigates to edit product from list" do
      expect {
        click_link_or_button "Products"
        find('.edit-icon').trigger("click")
      }.not_to change(Product, :count)

      expect(page).to have_current_path(edit_admin_product_path(1))
      expect(page).to have_content("Edit Product")
    end

    it "saves product edits" do
      expect {
        click_link_or_button "Products"
        find('.edit-icon').trigger("click")
        click_link_or_button "Save"
      }.not_to change(Product, :count)

      expect(page).to have_current_path(admin_product_path(1))
      expect(page).to have_content("Product Details")
    end

    it "cancels editing product" do
      expect {
        click_link_or_button "Products"
        find('.edit-icon').trigger("click")
        click_link_or_button "Cancel"
      }.not_to change(Product, :count)

      expect(page).to have_current_path(admin_product_path(1))
      expect(page).to have_content("Product Details")
    end
  end

  context "when admin is signed in and product exists to delete" do
    before do
      @products = create_list(:product, 1)
      login_as_admin
    end

    it "deletes product from detail page" do
      expect {
        click_link_or_button "Products"
        find('.show-icon').trigger("click")
        click_link_or_button "Delete"
      }.to change(Product, :count).from(1).to(0)

      expect(page).to have_current_path(admin_products_path)
      expect(page).to have_content("Products")
    end

    it "deletes product from list" do
      expect {
        click_link_or_button "Products"
        find('.trash-icon').trigger("click")
      }.to change(Product, :count).from(1).to(0)

      expect(page).to have_current_path(admin_products_path)
      expect(page).to have_content("Products")
    end
  end
end
