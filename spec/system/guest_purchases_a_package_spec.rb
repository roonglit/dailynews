require 'rails_helper'

describe "Guest purchases a package" do
  context "a monthly subscription product exists" do
    before { create(:monthly_subscription_product) }

    it "can pay with credit card successfully" do
      # visit home page
      visit root_path
      # clicks for subscription
      click_link_or_button "subscribe"
      expect(page).not_to have_content "subscribe"
      expect(page).to have_content("Continue to Payment")
      # continue for a payment, and required to sign up
      # continue for a payment
      # fill in credit card info
      # see the complete page
      # visit library and see the content
    end
  end
end