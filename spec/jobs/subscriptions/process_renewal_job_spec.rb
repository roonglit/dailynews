require 'rails_helper'

RSpec.describe Subscriptions::ProcessRenewalJob, type: :job do
  let(:member) { create(:member, omise_customer_id: "cust_test_123") }
  let(:product) { create(:product, sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION", amount_cents: 24900) }
  let(:order) { create(:order, member: member, product: product, state: :paid) }
  let(:subscription) do
    create(:subscription,
      member: member,
      order: order,
      auto_renew: true,
      start_date: 1.month.ago,
      end_date: Date.current,
      renewal_status: :processing,
      renewal_attempts: 0
    )
  end

  let(:omise_customer) { double('Omise::Customer', id: 'cust_test_123') }
  let(:omise_charge) { double('Omise::Charge', id: 'chrg_test_123', paid: true, failure_message: nil) }

  before do
    allow(Omise::Customer).to receive(:retrieve).with(member.omise_customer_id).and_return(omise_customer)
    allow(Omise::Charge).to receive(:create).and_return(omise_charge)
  end

  describe "#perform" do
    context "when payment succeeds" do
      # Force subscription creation before tests run
      before do
        subscription
        allow(omise_charge).to receive(:paid).and_return(true)
      end

      it "increments the renewal attempts counter" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.renewal_attempts }.from(0).to(1)
      end

      it "stamps the last renewal attempt timestamp" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.last_renewal_attempt_at }.from(nil).to(kind_of(Time))
      end

      it "stamps the renewal succeeded timestamp" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.renewal_succeeded_at }.from(nil).to(kind_of(Time))
      end

      it "creates a new order" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { member.orders.count }.by(1)
      end

      it "creates an order with correct amounts" do
        described_class.new.perform(subscription.id)

        new_order = member.orders.last
        expect(new_order.total_cents).to eq(24900)
        expect(new_order.sub_total_cents).to eq((24900 / 1.07).round)
      end

      it "charges the customer via Omise" do
        described_class.new.perform(subscription.id)

        expect(Omise::Charge).to have_received(:create).with(
          hash_including(
            amount: 24900,
            currency: "thb",
            customer: omise_customer.id,
            recurring_reason: "subscription"
          )
        )
      end

      it "marks the old subscription as succeeded" do
        described_class.new.perform(subscription.id)
        expect(subscription.reload.renewal_status).to eq("succeeded")
      end

      it "creates a new subscription" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { member.subscriptions.count }.by(1)
      end

      it "creates a new subscription starting after the old one ends" do
        described_class.new.perform(subscription.id)

        new_subscription = member.subscriptions.last
        expect(new_subscription.start_date).to eq(subscription.end_date + 1.day)
        # End date is start + 1 month (calendar month, not 30 days)
        expect(new_subscription.end_date).to eq(new_subscription.start_date + 1.month)
      end

      it "sends a success email" do
        expect {
          described_class.new.perform(subscription.id)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('SubscriptionMailer', 'renewal_success', 'deliver_now', { args: [ subscription, kind_of(Subscription) ] })
      end
    end

    context "when payment fails 2 days before expiration" do
      let(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 2.days,
          renewal_status: :processing,
          renewal_attempts: 0
        )
      end

      before do
        subscription  # Force creation
        allow(omise_charge).to receive(:paid).and_return(false)
        allow(omise_charge).to receive(:failure_message).and_return("Insufficient funds")
      end

      it "increments the renewal attempts counter" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.renewal_attempts }.from(0).to(1)
      end

      it "marks the subscription as failed" do
        described_class.new.perform(subscription.id)
        expect(subscription.reload.renewal_status).to eq("failed")
      end

      it "stamps the last renewal attempt timestamp" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.last_renewal_attempt_at }.from(nil).to(kind_of(Time))
      end

      it "stamps the renewal failed timestamp" do
        expect {
          described_class.new.perform(subscription.id)
        }.to change { subscription.reload.renewal_failed_at }.from(nil).to(kind_of(Time))
      end

      it "does not set renewal succeeded timestamp" do
        described_class.new.perform(subscription.id)
        expect(subscription.reload.renewal_succeeded_at).to be_nil
      end

      it "does not create a new subscription" do
        expect {
          described_class.new.perform(subscription.id)
        }.not_to change { member.subscriptions.count }
      end

      it "sends the day_2 failure email" do
        expect {
          described_class.new.perform(subscription.id)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('SubscriptionMailer', 'renewal_failed_day_2', 'deliver_now', { args: [ subscription ] })
      end
    end

    context "when payment fails 1 day before expiration" do
      let(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current + 1.day,
          renewal_status: :processing,
          renewal_attempts: 1
        )
      end

      before do
        allow(omise_charge).to receive(:paid).and_return(false)
        allow(omise_charge).to receive(:failure_message).and_return("Card declined")
      end

      it "sends the day_1 failure email" do
        expect {
          described_class.new.perform(subscription.id)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('SubscriptionMailer', 'renewal_failed_day_1', 'deliver_now', { args: [ subscription ] })
      end
    end

    context "when payment fails on expiration day (final attempt)" do
      let(:subscription) do
        create(:subscription,
          member: member,
          order: order,
          auto_renew: true,
          start_date: 1.month.ago,
          end_date: Date.current,
          renewal_status: :processing,
          renewal_attempts: 2
        )
      end

      before do
        allow(omise_charge).to receive(:paid).and_return(false)
        allow(omise_charge).to receive(:failure_message).and_return("Card expired")
      end

      it "sends the final failure email" do
        expect {
          described_class.new.perform(subscription.id)
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with('SubscriptionMailer', 'renewal_failed_final', 'deliver_now', { args: [ subscription ] })
      end
    end

    context "when product is missing" do
      let(:order_without_product) { create(:order, member: member, state: :paid) }
      let(:subscription_without_product) do
        create(:subscription,
          member: member,
          order: order_without_product,
          auto_renew: true,
          end_date: Date.current,
          renewal_status: :processing
        )
      end

      it "marks the subscription as failed" do
        described_class.new.perform(subscription_without_product.id)
        expect(subscription_without_product.reload.renewal_status).to eq("failed")
      end

      it "does not attempt to charge" do
        described_class.new.perform(subscription_without_product.id)
        expect(Omise::Charge).not_to have_received(:create)
      end
    end

    context "when Omise raises an error" do
      before do
        allow(Omise::Charge).to receive(:create).and_raise(Omise::Error.new("Connection error"))
      end

      it "marks the subscription as failed" do
        expect {
          described_class.new.perform(subscription.id)
        }.to raise_error(Omise::Error)

        expect(subscription.reload.renewal_status).to eq("failed")
      end

      it "logs the error" do
        allow(Rails.logger).to receive(:error)

        expect {
          described_class.new.perform(subscription.id)
        }.to raise_error(Omise::Error)

        expect(Rails.logger).to have_received(:error).with(/Subscription renewal failed/)
      end
    end
  end
end
