require 'rails_helper'

describe "Admin Can Edit Product" do
  before { @products = create_list(:product, 1) }

  it "navigates to edit product from detail page" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.show-icon').click
      click_link_or_button "Edit"
    }.not_to change(Product, :count)

    expect(page).to have_current_path(edit_admin_product_path(1))
    expect(page).to have_content("Edit Product")
  end

  it "navigates to edit product from list" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.edit-icon').click
    }.not_to change(Product, :count)

    expect(page).to have_current_path(edit_admin_product_path(1))
    expect(page).to have_content("Edit Product")
  end

  it "saves product edits" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.edit-icon').click
      click_link_or_button "Save"
    }.not_to change(Product, :count)

    expect(page).to have_current_path(admin_product_path(1))
    expect(page).to have_content("Product Details")
  end
end
