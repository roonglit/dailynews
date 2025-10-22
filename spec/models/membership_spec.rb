require 'rails_helper'

RSpec.describe Membership, type: :model do
  it "not create then start_date is nil" do
    membership = build(:membership, start_date: nil)
    expect(membership).not_to be_valid
    expect(membership.errors[:start_date]).to include("can't be blank")
  end

  it "not create then end_date is nil" do
    membership = build(:membership, end_date: nil)
    expect(membership).not_to be_valid
    expect(membership.errors[:end_date]).to include("can't be blank")
  end

  it "can create membership with valid data" do
    membership = create(:membership)
    expect(membership).to be_valid
    expect(Membership.first.start_date).to eq(membership.start_date)
  end

  it "membership is active" do
    membership = build(:membership)
    expect(membership.active?).to eq(true)
  end

  it "membership is inactive" do
    membership = build(:membership, start_date: 2.months.ago, end_date: 1.month.ago)
    expect(membership.active?).to eq(false)
  end
end
