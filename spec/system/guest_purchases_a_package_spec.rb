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
      expect(page).to have_content "Thank You for Your Purchase"

      # customer should see information of his subscription
      find('.user-profile').click
      click_link_or_button "Subscriptions & Payments"
      expect(page).to have_content "Subscription Details"

      within("#my-subscriptions") do
        expect(page).to have_content("ACTIVE")
        expect(page).to have_content("Renews on")
      end
    end

    context "member exists" do
      let(:existing_member) { create(:member) }

      it "allows existing member to login from sign up dialog and complete purchase" do
        # visit home page as guest
        visit root_path

        # clicks for subscription
        click_button "subscribe"
        expect(page).to have_content("Product added to cart")

        # continue for payment, should show sign up dialog
        click_link_or_button "Continue to Payment"
        expect(page).to have_content("Sign Up")

        # choose to login instead of signing up
        click_link "Sign in here"
        expect(page).to have_content("Sign In")

        # fill in existing member credentials
        fill_in 'email', with: existing_member.email
        fill_in 'password', with: 'password123'
        click_link_or_button 'SIGN IN'

        # should be logged in successfully
        expect(page).to have_content('Signed in successfully.')

        # continue with payment using Omise
        user_pays_with_omise(token: 'tokn_test_5mokdpoelz84n3ai99l')

        # After payment submission, should be redirected through 3DS flow
        # and eventually land on the complete page
        expect(page).to have_content "Thank You for Your Purchase"

        # verify subscription was created
        find('.user-profile').click
        click_link_or_button "Subscriptions & Payments"
        expect(page).to have_content "Subscription Details"

        within("#my-subscriptions") do
          expect(page).to have_content("ACTIVE")
          expect(page).to have_content("Renews on")
        end
      end

      it "shows error and redirects to checkout when payment fails" do
        # visit home page as guest
        visit root_path

        # clicks for subscription
        click_button "subscribe"
        expect(page).to have_content("Product added to cart")
        product = Product.last

        # continue for payment, should show sign up dialog
        click_link_or_button "Continue to Payment"
        expect(page).to have_content("Sign Up")

        # choose to login instead of signing up
        click_link "Sign in here"
        expect(page).to have_content("Sign In")

        # fill in existing member credentials
        fill_in 'email', with: existing_member.email
        fill_in 'password', with: 'password123'
        click_link_or_button 'SIGN IN'

        # should be logged in successfully
        expect(page).to have_content('Signed in successfully.')

        # attempt payment but it fails
        user_pays_with_omise_but_fails

        # should be redirected to checkout page with error
        expect(page).to have_current_path(checkout_path)
        expect(page).to have_content("Payment failed. Please try again.")

        # verify order was marked as cancelled
        order = Order.last
        expect(order.state).to eq("cancelled")

        # verify cart was recreated with the product
        cart = existing_member.reload.cart
        expect(cart.product).to eq(product)

        # verify user can see the product in cart to retry
        expect(page).to have_content(product.title)
      end
    end
  end
end