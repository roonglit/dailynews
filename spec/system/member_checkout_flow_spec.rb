require 'rails_helper'

describe "Member checkout flow", js: true do
  include OmiseHelpers

  let!(:product) { create(:monthly_subscription_product) }
  let(:existing_member) { create(:member) }

  it "allows existing member to login from signup modal and complete purchase" do
    # Visit home page as guest (not logged in)
    visit root_path

    # Add product to cart
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # Continue to payment, should show signup modal
    click_link_or_button "Continue to Payment"
    expect(page).to have_content("Sign Up")

    # Switch to login form
    click_link "Sign in here"
    expect(page).to have_content("Sign In")

    # Fill in existing member credentials
    fill_in 'email', with: existing_member.email
    fill_in 'password', with: 'password123'
    click_link_or_button 'SIGN IN'

    # Should be logged in successfully
    expect(page).to have_content('Signed in successfully.')

    # Continue with payment using Omise
    user_pays_with_omise(token: 'tokn_test_5mokdpoelz84n3ai99l')

    # Should be redirected to success page after payment
    expect(page).to have_content "Thank You for Your Purchase"

    # Verify subscription was created - navigate to subscription page
    find('.user-profile').click
    click_link_or_button "Subscriptions & Payments"
    expect(page).to have_content "Subscription Details"

    # Verify subscription is active
    within("#my-subscriptions") do
      expect(page).to have_content("ACTIVE")
      expect(page).to have_content("Renews on")
    end
  end

  it "shows product details in checkout for logged-in member" do
    # Login as existing member first
    login_as_user(existing_member)

    # Visit home page and add product to cart
    visit root_path
    click_button "subscribe"

    # Should be on checkout page
    expect(page).to have_current_path(checkout_path)

    # Should see product details
    expect(page).to have_content("Order Summary")
    expect(page).to have_content(product.title)

    # Should see tax breakdown
    expect(page).to have_content("Subtotal")
    expect(page).to have_content("VAT (7%)")
    expect(page).to have_content("Total")

    # Should see payment button (not auth modal trigger)
    expect(page).to have_button("Continue to Payment")
  end

  it "preserves cart after login" do
    # Visit home page as guest
    visit root_path

    # Add product to cart
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # Trigger auth modal
    click_link_or_button "Continue to Payment"

    # Switch to login and sign in
    click_link "Sign in here"
    fill_in 'email', with: existing_member.email
    fill_in 'password', with: 'password123'
    click_link_or_button 'SIGN IN'

    # Cart should still contain the product
    expect(page).to have_content(product.title)
    expect(page).to have_content("Order Summary")
  end
end
