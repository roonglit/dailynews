require 'rails_helper'

describe "Admin Can Delete Product From List" do
  before { @products = create_list(:product, 1) }

  it "deletes product from list" do
    login_as_admin

    expect {
      click_link_or_button "Products"
      find('.trash-icon').click
    }.to change(Product, :count).from(1).to(0)

    expect(page).to have_current_path(admin_products_path)
    expect(page).to have_content("Products")
  end
end
