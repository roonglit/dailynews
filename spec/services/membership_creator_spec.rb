require 'rails_helper'

RSpec.describe MembershipCreator do
  let(:user) { create(:member) }
  let(:product) { create(:product, sku: "MEMBERSHIP_ONE_MONTH", title: "1 Month", amount: 299) }
  let(:order) do
    order = user.orders.create!(
      sub_total: Money.new(29900, "THB"),
      total: Money.new(29900, "THB")
    )
    order.create_order_item!(product: product)
    order
  end

  describe "#call" do
    subject(:creator) { described_class.new(order) }

    context "with a valid order" do
      it "creates a membership" do
        expect { creator.call }.to change(Membership, :count).by(1)
      end

      it "links the membership to the order" do
        creator.call
        expect(order.reload.membership).to be_present
      end

      it "links the membership to the user" do
        creator.call
        expect(order.membership.user).to eq(user)
      end

      it "sets start_date to today" do
        creator.call
        expect(order.membership.start_date).to eq(Date.current)
      end

      it "sets end_date to 1 month from today" do
        creator.call
        expect(order.membership.end_date).to eq(Date.current + 1.month)
      end

      it "returns true" do
        expect(creator.call).to be true
      end
    end

    context "with MEMBERSHIP_MONTHLY_SUBSCRIPTION product" do
      let(:product) { create(:product, sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION", title: "Monthly", amount: 249) }

      it "sets end_date to 1 month from today" do
        creator.call
        expect(order.membership.end_date).to eq(Date.current + 1.month)
      end
    end

    context "with unknown product SKU" do
      let(:product) { create(:product, sku: "UNKNOWN_SKU", title: "Unknown", amount: 100) }

      it "defaults to 1 month duration" do
        creator.call
        expect(order.membership.end_date).to eq(Date.current + 1.month)
      end
    end

    context "without a product" do
      let(:order) do
        user.orders.create!(
          sub_total: Money.new(29900, "THB"),
          total: Money.new(29900, "THB")
        )
      end

      it "returns false" do
        expect(creator.call).to be false
      end

      it "does not create a membership" do
        expect { creator.call }.not_to change(Membership, :count)
      end
    end
  end
end
