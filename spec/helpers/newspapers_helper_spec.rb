require 'rails_helper'

RSpec.describe NewspapersHelper, type: :helper do
  let(:user) { create(:user) }
  let(:newspaper) { create(:newspaper) }

  describe "check_newspaper_memberships" do
    context "when user has a valid membership" do
      it "returns true" do
        create(:membership, user: user, start_date: newspaper.published_at.to_date, end_date: Date.today)
        expect(check_newspaper_memberships(newspaper, user)).to be true
      end
    end

    context "when user have memberships but start date of memberships is less than the date of newspaper was published" do
      it "returns true" do
        create(:membership, user: user, start_date: Date.today - 2, end_date: Date.today + 1)
        expect(check_newspaper_memberships(newspaper, user)).to be true
      end
    end

    context "when user have memberships but start date of memberships is greater than the date of newspaper was published" do
      it "returns false" do
        create(:membership, user: user, start_date: Date.today + 1, end_date: Date.today + 2)
        expect(check_newspaper_memberships(newspaper, user)).to be false
      end
    end

    context "when user have membership expires" do
      it "returns false" do
        create(:membership, user: user, start_date: Date.today - 2, end_date: Date.today - 1)
        expect(check_newspaper_memberships(newspaper, user)).to be false
      end
    end

    context "when user has no memberships" do
      it "returns false" do
        expect(check_newspaper_memberships(newspaper, user)).to be false
      end
    end

    context "when user not login" do
      it "returns false" do
        expect(check_newspaper_memberships(newspaper, nil)).to be false
      end
    end
  end
end
