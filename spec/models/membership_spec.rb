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
end
