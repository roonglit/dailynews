require 'rails_helper'

describe "Payment failure handling", js: true do
  include OmiseHelpers

  let!(:product) { create(:monthly_subscription_product) }
  let(:existing_member) { create(:member) }

  before do
    # Login as existing member for all tests
    login_as_user(existing_member)
  end

  context "when payment fails" do
    before do
      # Add product to cart
      visit root_path
      click_button "subscribe"

      # Attempt payment but it fails
      user_pays_with_omise_but_fails
    end

    it "shows error message and keeps product in cart for retry" do
      # Should be redirected to checkout page with error
      expect(page).to have_current_path(checkout_path)
      expect(page).to have_content("Payment failed. Please try again.")

      # User can see the product in cart to retry
      expect(page).to have_content(product.title)
      expect(page).to have_content("Order Summary")
    end
  end

  context "retrying failed payment" do
    before do
      # Add product to cart
      visit root_path
      click_button "subscribe"

      # First attempt - payment fails
      user_pays_with_omise_but_fails
    end

    it "allows user to retry payment and succeed" do
      # Should be back on checkout page
      expect(page).to have_current_path(checkout_path)
      expect(page).to have_content("Payment failed. Please try again.")

      # Second attempt - payment succeeds
      user_pays_with_omise(token: 'tokn_test_5mokdpoelz84n3ai99l')

      # Should complete successfully
      expect(page).to have_content "Thank You for Your Purchase"

      # Verify subscription was created after retry
      find('.user-profile').click
      click_link_or_button "Subscriptions & Payments"

      within("#my-subscriptions") do
        expect(page).to have_content("ACTIVE")
      end
    end
  end
end
