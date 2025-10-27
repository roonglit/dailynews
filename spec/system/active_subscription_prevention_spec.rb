require 'rails_helper'

describe "Active subscription prevention", js: true do
  let!(:product) { create(:monthly_subscription_product) }

  context "when member has active subscription" do
    let(:member) { create(:member) }
    let!(:subscription) { create(:subscription, user: member, start_date: Date.today, end_date: Date.today + 1.month) }

    it "shows 'Go to Library' button on home page instead of subscribe button" do
      login_as_user(member)
      visit root_path

      # Should show "Go to Library" button
      expect(page).to have_content(I18n.t("home.active_subscription_title"))
      expect(page).to have_content(I18n.t("home.active_subscription_message"))
      expect(page).to have_link(I18n.t("home.go_to_library"), href: library_path)

      # Should NOT show subscribe button
      expect(page).not_to have_button("subscribe")
    end

    it "redirects to library when trying to access checkout page" do
      login_as_user(member)
      visit checkout_path

      # Should redirect to library
      expect(page).to have_current_path(library_path)
      expect(page).to have_content("You already have an active subscription")
    end

    it "does not show subscribe button, preventing cart addition from UI" do
      login_as_user(member)
      visit root_path

      # The subscribe button should not be present, preventing cart addition
      expect(page).not_to have_button("subscribe")

      # The "Go to Library" link should be present instead
      expect(page).to have_link(I18n.t("home.go_to_library"), href: library_path)
    end
  end

  context "when member does not have active subscription" do
    let(:member) { create(:member) }

    it "shows subscribe button on home page" do
      login_as_user(member)
      visit root_path

      # Should show subscribe button
      expect(page).to have_button("subscribe")

      # Should NOT show "Go to Library" message
      expect(page).not_to have_content(I18n.t("home.active_subscription_title"))
      expect(page).not_to have_link(I18n.t("home.go_to_library"))
    end

    it "can access checkout page" do
      login_as_user(member)

      # Add product to cart first
      visit root_path
      click_button "subscribe"
      expect(page).to have_content("Product added to cart")

      # Should be able to access checkout
      expect(page).to have_current_path(checkout_path)
      expect(page).to have_content("Order Summary")
    end
  end

  context "when member has expired subscription" do
    let(:member) { create(:member) }
    let!(:expired_subscription) { create(:subscription, user: member, start_date: 2.months.ago, end_date: 1.month.ago) }

    it "shows subscribe button on home page" do
      login_as_user(member)
      visit root_path

      # Should show subscribe button (subscription is expired)
      expect(page).to have_button("subscribe")

      # Should NOT show "Go to Library" message
      expect(page).not_to have_content(I18n.t("home.active_subscription_title"))
    end

    it "can access checkout page" do
      login_as_user(member)

      # Add product to cart first
      visit root_path
      click_button "subscribe"
      expect(page).to have_content("Product added to cart")

      # Should be able to access checkout (subscription is expired)
      expect(page).to have_current_path(checkout_path)
      expect(page).to have_content("Order Summary")
    end
  end
end
