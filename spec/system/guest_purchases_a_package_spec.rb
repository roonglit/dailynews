require 'rails_helper'

describe "guest purchases a package", js: true do
  include OmiseHelpers

  context "a monthly subscription product exists" do
    before { create(:monthly_subscription_product) }

    it "can pay with credit card successfully" do
      # visit home page
      visit root_path

      # clicks for subscription
      click_link_or_button "subscribe"
      expect(page).not_to have_content "subscribe"

      # continue for a payment, and required to sign up
      click_link_or_button "Continue to Payment"
      fill_in 'email', with: "guest@example.com"
      fill_in 'password', with: 'password123'
      fill_in 'confirm_password', with: 'password123'
      click_link_or_button 'SIGN UP'

      # fill in credit card info and submit payment
      user_pays_with_omise(token: 'tokn_test_5mokdpoelz84n3ai99l')

      # After payment submission, should be redirected through 3DS flow
      # and eventually land on the complete page
      expect(page).to have_content "Thank You for Your Purchase", wait: 10
    end
  end
end