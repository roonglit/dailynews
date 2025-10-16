require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:one_month) { create(:one_month) }

  it "not create then title is nil" do
    product = build(:product, title: nil)
    expect(product).not_to be_valid
    expect(product.errors[:title]).to include("can't be blank")
  end

  it "not create then amount is nil" do
    product = build(:product, amount: nil)
    expect(product).not_to be_valid
    expect(product.errors[:amount]).to include("can't be blank")
  end

  it "not create then sku is nil" do
    product = build(:product, sku: nil)
    expect(product).not_to be_valid
    expect(product.errors[:sku]).to include("can't be blank")
  end

  it "is invalid with a duplicate title" do
    product = build(:product, title: one_month.title)
    expect(product).not_to be_valid
    expect(product.errors[:title]).to include("has already been taken")
  end

  it "is invalid with a duplicate sku" do
    product = build(:product, sku: one_month.sku)
    expect(product).not_to be_valid
    expect(product.errors[:sku]).to include("has already been taken")
  end

  it "is valid with all required attributes" do
    product = build(:product, title: "New Product", amount: 100, sku: "NEW_SKU")
    expect(product).to be_valid
  end
end
