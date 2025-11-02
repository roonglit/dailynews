require 'rails_helper'

describe "Admin Can View Product Details" do
  before { @products = create_list(:product, 1) }

  it "navigates to product detail page" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.show-icon').click
    }.not_to change(Product, :count)

    expect(page).to have_current_path(admin_product_path(1))
    expect(page).to have_content("Product Details")
  end

  it "navigates back from product detail page" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.show-icon').click
      click_link_or_button "Back to list"
    }.not_to change(Product, :count)

    expect(page).to have_current_path(admin_products_path)
    expect(page).to have_content("Products")
  end
end
