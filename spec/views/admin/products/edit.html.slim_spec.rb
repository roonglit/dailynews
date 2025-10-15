require 'rails_helper'

RSpec.describe "admin/products/edit", type: :view do
  let(:admin_product) {
    Admin::Product.create!()
  }

  before(:each) do
    assign(:admin_product, admin_product)
  end

  it "renders the edit admin_product form" do
    render

    assert_select "form[action=?][method=?]", admin_product_path(admin_product), "post" do
    end
  end
end
