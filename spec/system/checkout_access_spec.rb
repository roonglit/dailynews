require 'rails_helper'

describe "Checkout access", js: true do
  let!(:product) { create(:monthly_subscription_product) }

  context "as a guest" do
    it "get checkout path without click button subscribe" do
      # Visit home page as guest
      visit root_path

      # Open checkout with url path
      visit checkout_path

      # Should stay on root path
      expect(page).to have_current_path(root_path)
    end

    it "get checkout path with subscribe click button" do
      # Visit home page as guest
      visit root_path

      # Click subscribe button
      click_button "subscribe"

      # Back to home page as guest
      visit root_path

      # Open checkout with url path
      visit checkout_path

      # Should stay on root path
      expect(page).to have_current_path(checkout_path)

      # Checkout page should be visible
      expect(page).to have_content("Order Summary")
    end

    it "can add product to cart and reach checkout page" do
      # Visit home page as guest
      visit root_path

      # Click subscribe button
      click_button "subscribe"

      # Should show success message
      expect(page).to have_content("Product added to cart")

      # Should be redirected to checkout page
      expect(page).to have_current_path(checkout_path)

      # Checkout page should be visible
      expect(page).to have_content("Order Summary")
    end

    it "sees authentication modal when clicking payment button" do
      # Visit home page and add product to cart
      visit root_path
      click_button "subscribe"

      # Should be on checkout page
      expect(page).to have_current_path(checkout_path)

      # Click Continue to Payment
      click_link_or_button "Continue to Payment"

      # Should see auth modal (not payment processing)
      expect(page).to have_content("Sign Up")
      expect(page).to have_field('email')
      expect(page).to have_field('password')
    end

    it "sees product information on checkout page" do
      # Visit home page and add product to cart
      visit root_path
      click_button "subscribe"

      # Should see product details
      expect(page).to have_content(product.title)
      expect(page).to have_content("Order Summary")

      # Should see selected plan section
      expect(page).to have_content("Selected Plan")
    end

    it "sees tax breakdown on checkout page" do
      # Visit home page and add product to cart
      visit root_path
      click_button "subscribe"

      # Should see tax information
      expect(page).to have_content("Subtotal")
      expect(page).to have_content("VAT (7%)")
      expect(page).to have_content("Total")
    end
  end

  context "as a member" do
    let(:member) { create(:member) }

    before do
      login_as_user(member)
    end

    it "get checkout path without click button subscribe" do
      # Visit home page as guest
      visit root_path

      # Open checkout with url path
      visit checkout_path

      # Should stay on root path
      expect(page).to have_current_path(root_path)
    end

    it "can add product to cart and reach checkout page" do
      # Visit home page
      visit root_path

      # Click subscribe button
      click_button "subscribe"

      # Should show success message
      expect(page).to have_content("Product added to cart")

      # Should be redirected to checkout page
      expect(page).to have_current_path(checkout_path)

      # Checkout page should be visible
      expect(page).to have_content("Order Summary")
    end

    it "sees payment button instead of auth modal" do
      # Visit home page and add product to cart
      visit root_path
      click_button "subscribe"

      # Should be on checkout page
      expect(page).to have_current_path(checkout_path)

      # Should see Continue to Payment button
      expect(page).to have_button("Continue to Payment")

      # Should NOT trigger auth modal (member already logged in)
      # The button should be set up to trigger Omise payment
    end

    it "sees product information on checkout page" do
      # Visit home page and add product to cart
      visit root_path
      click_button "subscribe"

      # Should see product details
      expect(page).to have_content(product.title)
      expect(page).to have_content("Order Summary")

      # Should see selected plan section
      expect(page).to have_content("Selected Plan")
    end

    it "can access checkout page directly if cart exists" do
      # Add product to cart first
      visit root_path
      click_button "subscribe"

      # Leave checkout page
      visit root_path

      # Can access checkout directly
      visit checkout_path
      expect(page).to have_current_path(checkout_path)
      expect(page).to have_content("Order Summary")
      expect(page).to have_content(product.title)
    end
  end

  context "as a member and have subscription" do
    let(:member_have_subscription) { create(:member) }
    let!(:subscription) { create(:subscription, user: member_have_subscription) }

    before do
      login_as_user(member_have_subscription)
    end

    it "get checkout path without click button subscribe" do
      # Visit home page as guest
      visit root_path

      # Open checkout with url path
      visit checkout_path

      # Should stay on root path
      expect(page).to have_current_path(library_path)
    end
  end
end
