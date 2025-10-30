require 'rails_helper'

RSpec.describe Subscriptions::EnqueueRenewalsJob, type: :job do
  let(:member) { create(:member, omise_customer_id: "cust_test_123") }
  let(:product) { create(:product, sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION") }
  let(:order) { create(:order, member: member, product: product, state: :paid) }

  describe "#perform" do
    context "when subscription expires today" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current,
          renewal_status: :pending
        )
      end

      it "enqueues a renewal job" do
        expect {
          described_class.new.perform
        }.to have_enqueued_job(Subscriptions::ProcessRenewalJob).with(subscription.id)
      end

      it "marks the subscription as processing" do
        described_class.new.perform
        expect(subscription.reload.renewal_status).to eq("processing")
      end
    end

    context "when subscription expires in 1 day" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 1.day,
          renewal_status: :pending
        )
      end

      it "enqueues a renewal job" do
        expect {
          described_class.new.perform
        }.to have_enqueued_job(Subscriptions::ProcessRenewalJob).with(subscription.id)
      end
    end

    context "when subscription expires in 2 days" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 2.days,
          renewal_status: :pending
        )
      end

      it "enqueues a renewal job" do
        expect {
          described_class.new.perform
        }.to have_enqueued_job(Subscriptions::ProcessRenewalJob).with(subscription.id)
      end
    end

    context "when subscription expires in 3 days" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 3.days,
          renewal_status: :pending
        )
      end

      it "does not enqueue a renewal job" do
        expect {
          described_class.new.perform
        }.not_to have_enqueued_job(Subscriptions::ProcessRenewalJob)
      end
    end

    context "when subscription has auto_renew disabled" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: false,
          start_date: 1.month.ago,
          end_date: Date.current,
          renewal_status: :pending
        )
      end

      it "does not enqueue a renewal job" do
        expect {
          described_class.new.perform
        }.not_to have_enqueued_job(Subscriptions::ProcessRenewalJob)
      end
    end

    context "when subscription renewal has already succeeded" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current,
          renewal_status: :succeeded
        )
      end

      it "does not enqueue a renewal job" do
        expect {
          described_class.new.perform
        }.not_to have_enqueued_job(Subscriptions::ProcessRenewalJob)
      end
    end

    context "when subscription renewal is already processing" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current,
          renewal_status: :processing
        )
      end

      it "does not enqueue a renewal job" do
        expect {
          described_class.new.perform
        }.not_to have_enqueued_job(Subscriptions::ProcessRenewalJob)
      end
    end

    context "when subscription renewal previously failed (retry scenario)" do
      let!(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 1.day,
          renewal_status: :failed,
          renewal_attempts: 1
        )
      end

      it "enqueues a renewal job for retry" do
        expect {
          described_class.new.perform
        }.to have_enqueued_job(Subscriptions::ProcessRenewalJob).with(subscription.id)
      end

      it "marks the subscription as processing" do
        described_class.new.perform
        expect(subscription.reload.renewal_status).to eq("processing")
      end
    end

    context "when user already has a newer subscription" do
      let!(:old_subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 2.months.ago,
          end_date: Date.current,
          renewal_status: :pending
        )
      end

      let(:new_order) { create(:order, member: member, product: product, state: :paid) }
      let!(:new_subscription) do
        create(:subscription,
          member: member,
          order: new_order,
          start_date: Date.current + 1.day,
          end_date: Date.current + 1.month + 1.day,
          renewal_status: :pending
        )
      end

      it "does not enqueue a renewal job for the old subscription" do
        expect {
          described_class.new.perform
        }.not_to have_enqueued_job(Subscriptions::ProcessRenewalJob)
      end

      it "does not mark the old subscription as processing" do
        described_class.new.perform
        expect(old_subscription.reload.renewal_status).to eq("pending")
      end
    end

    context "with multiple subscriptions meeting criteria" do
      let(:member2) { create(:member, omise_customer_id: "cust_test_456") }
      let(:order2) { create(:order, member: member2, product: product, state: :paid) }

      let!(:subscription1) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          end_date: Date.current,
          renewal_status: :pending
        )
      end

      let!(:subscription2) do
        create(:subscription,
          member: member2,
          order: order2,
          auto_renew: true,
          end_date: Date.current + 1.day,
          renewal_status: :pending
        )
      end

      it "enqueues renewal jobs for all eligible subscriptions" do
        described_class.new.perform

        expect(Subscriptions::ProcessRenewalJob).to have_been_enqueued.with(subscription1.id)
        expect(Subscriptions::ProcessRenewalJob).to have_been_enqueued.with(subscription2.id)
      end
    end
  end
end
