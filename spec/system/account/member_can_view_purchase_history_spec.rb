require 'rails_helper'

describe "Purchase history", js: true do
  before do
    login_as_user(member)
  end

  context "when member has no orders" do
    let(:member) { create(:member) }

    it "shows empty state with call to action" do
      visit account_purchases_path

      # Should see empty state message
      expect(page).to have_content("You have no purchase history yet.")

      # Should have link to browse newspapers
      expect(page).to have_link("Browse Newspapers", href: root_path)
    end

    it "can navigate to home page from empty state" do
      visit account_purchases_path

      # Click browse newspapers link
      click_link "Browse Newspapers"

      # Should be on home page
      expect(current_path).to eq(root_path)
    end
  end

  context "when member has single paid order" do
    let(:member) { create(:member) }
    let(:product) { create(:monthly_subscription_product, title: "Monthly Subscription", amount: 100) }
    let!(:order) do
      create(:order,
        member: member,
        state: :paid,
        total_cents: 10000,
        created_at: Time.zone.parse("2025-01-15"))
    end
    let!(:order_item) { create(:order_item, order: order, product: product) }

    it "displays order details correctly" do
      visit account_purchases_path

      # Should see page header
      expect(page).to have_content("Purchase history")
      expect(page).to have_content("View your purchase history")

      # Should see product title
      expect(page).to have_content("Monthly Subscription")

      # Should see order ID
      expect(page).to have_content("Order ##{order.id}")

      # Should see formatted purchase date
      expect(page).to have_content("Purchased on January 15, 2025")

      # Should see PAID badge
      expect(page).to have_content("PAID")

      # Should see formatted amount
      expect(page).to have_content("฿100.00")
    end
  end

  context "when member has multiple orders with different states" do
    let(:member) { create(:member) }
    let(:product) { create(:monthly_subscription_product) }
    let!(:oldest_order) do
      create(:order,
        member: member,
        state: :paid,
        total_cents: 10000,
        created_at: 3.days.ago)
    end
    let!(:middle_order) do
      create(:order,
        member: member,
        state: :pending,
        total_cents: 15000,
        created_at: 2.days.ago)
    end
    let!(:newest_order) do
      create(:order,
        member: member,
        state: :cancelled,
        total_cents: 20000,
        created_at: 1.day.ago)
    end

    before do
      create(:order_item, order: oldest_order, product: product)
      create(:order_item, order: middle_order, product: product)
      create(:order_item, order: newest_order, product: product)
    end

    it "displays orders in descending chronological order" do
      visit account_purchases_path

      # Should show all three orders
      expect(page).to have_content("Order ##{oldest_order.id}")
      expect(page).to have_content("Order ##{middle_order.id}")
      expect(page).to have_content("Order ##{newest_order.id}")

      # Get all order elements
      order_ids = page.all('.border-b').filter_map do |element|
        match = element.text.match(/Order *#(\d+)/)
        match[1].to_i if match
      end

      # Should be in descending order (newest first)
      expect(order_ids).to eq([ newest_order.id, middle_order.id, oldest_order.id ])
    end

    it "displays correct status badge for each order" do
      visit account_purchases_path

      # Should show all three status badges
      expect(page).to have_content("PAID")
      expect(page).to have_content("PENDING")
      expect(page).to have_content("CANCELLED")
    end
  end

  context "when member has orders with different products and amounts" do
    let(:member) { create(:member) }
    let(:product_1) { create(:one_month_product, title: "1 Month Subscription", amount: 100) }
    let(:product_2) { create(:monthly_subscription_product, title: "Monthly Subscription", amount: 80) }
    let!(:order_1) do
      create(:order,
        member: member,
        state: :paid,
        total_cents: 10000,
        created_at: 2.days.ago)
    end
    let!(:order_2) do
      create(:order,
        member: member,
        state: :paid,
        total_cents: 8000,
        created_at: 1.day.ago)
    end

    before do
      create(:order_item, order: order_1, product: product_1)
      create(:order_item, order: order_2, product: product_2)
    end

    it "displays correct product title for each order" do
      visit account_purchases_path

      # Should show both product titles
      expect(page).to have_content("1 Month Subscription")
      expect(page).to have_content("Monthly Subscription")
    end

    it "displays correct amount for each order" do
      visit account_purchases_path

      # Should show formatted amounts
      expect(page).to have_content("฿100.00")
      expect(page).to have_content("฿80.00")
    end
  end

  context "when viewing another member's orders" do
    let(:member) { create(:member, email: "member1@gmail.com") }
    let(:other_member) { create(:member, email: "member2@gmail.com") }
    let(:product) { create(:monthly_subscription_product) }
    let!(:member_order) do
      create(:order, member: member, state: :paid, total_cents: 10000)
    end
    let!(:other_member_order) do
      create(:order, member: other_member, state: :paid, total_cents: 15000)
    end

    before do
      create(:order_item, order: member_order, product: product)
      create(:order_item, order: other_member_order, product: product)
    end

    it "only shows current member's orders" do
      visit account_purchases_path

      # Should see own order
      expect(page).to have_content("Order ##{member_order.id}")

      # Should NOT see other member's order
      expect(page).not_to have_content("Order ##{other_member_order.id}")
    end
  end
end
