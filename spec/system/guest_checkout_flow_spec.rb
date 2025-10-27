require 'rails_helper'

describe "Guest checkout flow", js: true do
  include OmiseHelpers

  let!(:product) { create(:monthly_subscription_product) }

  it "completes full purchase journey from guest to subscribed member" do
    # Guest visits home page
    visit root_path

    # Guest clicks subscribe button
    click_link_or_button "subscribe"
    expect(page).not_to have_content "subscribe"

    # Guest continues to payment and is prompted to sign up
    click_link_or_button "Continue to Payment"

    # Guest fills in signup form
    fill_in 'email', with: "newguest@example.com"
    fill_in 'password', with: 'password123'
    fill_in 'confirm_password', with: 'password123'
    click_link_or_button 'SIGN UP'

    # Guest completes payment with credit card
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

  it "shows product details during checkout" do
    # Guest visits home page and adds product to cart
    visit root_path
    click_link_or_button "subscribe"

    # Should see product details on checkout page
    expect(page).to have_content("Order Summary")
    expect(page).to have_content(product.title)

    # Should see tax breakdown
    expect(page).to have_content("Subtotal")
    expect(page).to have_content("VAT (7%)")
    expect(page).to have_content("Total")
  end

  it "requires authentication before payment" do
    # Guest visits home page and adds product to cart
    visit root_path
    click_link_or_button "subscribe"

    # Should be on checkout page
    expect(page).to have_current_path(checkout_path)

    # Click Continue to Payment should show auth modal, not process payment
    click_link_or_button "Continue to Payment"

    # Should see signup form
    expect(page).to have_content("Sign Up")
    expect(page).to have_field('email')
    expect(page).to have_field('password')
    expect(page).to have_field('confirm_password')
  end
end
