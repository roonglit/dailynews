require 'rails_helper'

describe "Payment failure handling", js: true do
  include OmiseHelpers

  let!(:product) { create(:monthly_subscription_product) }
  let(:existing_member) { create(:member) }

  before do
    # Login as existing member for all tests
    login_as_user(existing_member)
  end

  it "redirects to checkout page with error message when payment fails" do
    # Add product to cart
    visit root_path
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # Attempt payment but it fails
    user_pays_with_omise_but_fails

    # Should be redirected to checkout page with error
    expect(page).to have_current_path(checkout_path)
    expect(page).to have_content("Payment failed. Please try again.")
  end

  it "marks order as cancelled when payment fails" do
    # Add product to cart
    visit root_path
    click_button "subscribe"

    # Attempt payment but it fails
    user_pays_with_omise_but_fails

    # Verify order was marked as cancelled
    order = Order.last
    expect(order).to be_present
    expect(order.state).to eq("cancelled")
  end

  it "recreates cart with product after failed payment for retry" do
    # Add product to cart
    visit root_path
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # Attempt payment but it fails
    user_pays_with_omise_but_fails

    # Verify cart was recreated with the product
    cart = existing_member.reload.cart
    expect(cart).to be_present
    expect(cart.product).to eq(product)

    # Verify user can see the product in cart to retry
    expect(page).to have_content(product.title)
    expect(page).to have_content("Order Summary")
  end

  it "allows user to retry payment after initial failure" do
    # Add product to cart
    visit root_path
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # First attempt - payment fails
    user_pays_with_omise_but_fails

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

  it "does not create subscription when payment fails" do
    # Count subscriptions before
    initial_subscription_count = Subscription.count

    # Add product to cart
    visit root_path
    click_button "subscribe"

    # Attempt payment but it fails
    user_pays_with_omise_but_fails

    # Subscription count should not increase
    expect(Subscription.count).to eq(initial_subscription_count)
  end

  it "does not clear cart when payment fails" do
    # Add product to cart
    visit root_path
    click_button "subscribe"
    expect(page).to have_content("Product added to cart")

    # Attempt payment but it fails
    user_pays_with_omise_but_fails

    # Cart should still exist and contain product
    cart = existing_member.reload.cart
    expect(cart).to be_present
    expect(cart.cart_item).to be_present
    expect(cart.product).to eq(product)
  end
end
