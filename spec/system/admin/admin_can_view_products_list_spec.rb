require 'rails_helper'

describe "Admin Can View Products List" do
  it "navigates to products page" do
    login_as_admin

    click_link_or_button "Products"

    expect(page).to have_current_path(admin_products_path)
    expect(page).to have_content("Products")
  end
end
