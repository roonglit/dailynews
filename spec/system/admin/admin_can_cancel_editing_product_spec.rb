require 'rails_helper'

describe "Admin Can Cancel Editing Product" do
  before { @products = create_list(:product, 1) }

  it "cancels editing product" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.edit-icon').click
      click_link_or_button "Cancel"
    }.not_to change(Product, :count)

    expect(page).to have_current_path(admin_product_path(1))
    expect(page).to have_content("Product Details")
  end
end
