require 'rails_helper'

RSpec.describe SubscriptionMailer, type: :mailer do
  let(:member) { create(:member, email: 'test@example.com', first_name: 'John') }
  let(:product) { create(:product, sku: "MEMBERSHIP_MONTHLY_SUBSCRIPTION", amount_cents: 24900) }
  let(:old_order) { create(:order, member: member, product: product, state: :paid, total_cents: 24900) }
  let(:old_subscription) do
    create(:subscription,
      member: member,
      order: old_order,
      start_date: 1.month.ago,
      end_date: Date.current
    )
  end

  describe "#renewal_success" do
    let(:new_order) { create(:order, member: member, product: product, state: :paid, total_cents: 24900) }
    let(:new_subscription) do
      create(:subscription,
        member: member,
        order: new_order,
        start_date: Date.current + 1.day,
        end_date: Date.current + 1.month + 1.day
      )
    end

    let(:mail) { described_class.renewal_success(old_subscription, new_subscription) }

    it "sends to the member's email" do
      expect(mail.to).to eq([ member.email ])
    end

    it "has the correct subject" do
      expect(mail.subject).to match(/subscription has been renewed/i)
    end

    it "includes the member's first name" do
      expect(mail.body.encoded).to match(/John/)
    end

    it "includes the old subscription period" do
      expect(mail.body.encoded).to include(old_subscription.start_date.strftime("%B %d, %Y"))
      expect(mail.body.encoded).to include(old_subscription.end_date.strftime("%B %d, %Y"))
    end

    it "includes the new subscription period" do
      expect(mail.body.encoded).to include(new_subscription.start_date.strftime("%B %d, %Y"))
      expect(mail.body.encoded).to include(new_subscription.end_date.strftime("%B %d, %Y"))
    end

    it "includes the amount charged" do
      expect(mail.body.encoded).to match(/249/)
    end

    it "includes a link to account settings" do
      expect(mail.body.encoded).to include("account/subscriptions")
    end
  end

  describe "#renewal_failed_day_2" do
    let(:subscription) do
      create(:subscription,
        member: member,
        order: old_order,
        start_date: 1.month.ago,
        end_date: Date.current + 2.days,
        renewal_attempts: 1
      )
    end

    let(:mail) { described_class.renewal_failed_day_2(subscription) }

    it "sends to the member's email" do
      expect(mail.to).to eq([ member.email ])
    end

    it "has the correct subject" do
      expect(mail.subject).to match(/issue with your.*subscription renewal/i)
    end

    it "includes the member's first name" do
      expect(mail.body.encoded).to match(/John/)
    end

    it "mentions retry tomorrow" do
      expect(mail.body.encoded).to match(/try.*again tomorrow/i)
    end

    it "shows expiration is in 2 days" do
      expect(mail.body.encoded).to match(/2 days/)
    end

    it "includes a link to account settings" do
      expect(mail.body.encoded).to include("account/subscriptions")
    end

    it "lists common payment issues" do
      expect(mail.body.encoded).to match(/insufficient funds/i)
      expect(mail.body.encoded).to match(/expired.*card/i)
    end
  end

  describe "#renewal_failed_day_1" do
    let(:subscription) do
      create(:subscription,
        member: member,
        order: old_order,
        start_date: 1.month.ago,
        end_date: Date.current + 1.day,
        renewal_attempts: 2
      )
    end

    let(:mail) { described_class.renewal_failed_day_1(subscription) }

    it "sends to the member's email" do
      expect(mail.to).to eq([ member.email ])
    end

    it "has an urgent subject" do
      expect(mail.subject).to match(/urgent/i)
      expect(mail.subject).to match(/failed again/i)
    end

    it "includes the member's first name" do
      expect(mail.body.encoded).to match(/John/)
    end

    it "shows expiration is in 1 day" do
      expect(mail.body.encoded).to match(/1 day/)
    end

    it "mentions final attempt tomorrow" do
      expect(mail.body.encoded).to match(/final attempt.*tomorrow/i)
    end

    it "includes action required section" do
      expect(mail.body.encoded).to match(/action required/i)
    end

    it "includes a link to account settings" do
      expect(mail.body.encoded).to include("account/subscriptions")
    end
  end

  describe "#renewal_failed_final" do
    let(:subscription) do
      create(:subscription,
        member: member,
        order: old_order,
        start_date: 1.month.ago,
        end_date: Date.current,
        renewal_attempts: 3
      )
    end

    let(:mail) { described_class.renewal_failed_final(subscription) }

    it "sends to the member's email" do
      expect(mail.to).to eq([ member.email ])
    end

    it "has the correct subject" do
      expect(mail.subject).to match(/will expire today/i)
    end

    it "includes the member's first name" do
      expect(mail.body.encoded).to match(/John/)
    end

    it "mentions subscription expires today" do
      expect(mail.body.encoded).to match(/expire.*today/i)
    end

    it "explains access will end" do
      expect(mail.body.encoded).to match(/access.*will end/i)
    end

    it "includes instructions to renew manually" do
      expect(mail.body.encoded).to match(/manually renew/i)
    end

    it "includes a link to account settings" do
      expect(mail.body.encoded).to include("account/subscriptions")
    end
  end
end
