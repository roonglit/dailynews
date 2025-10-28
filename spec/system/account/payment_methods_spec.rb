require 'rails_helper'

describe "Payment methods", js: true do
  before do
    login_as_user(member)
  end

  context "when member has no Omise customer ID" do
    let(:member) { create(:member, omise_customer_id: nil) }

    it "shows empty state" do
      visit account_payment_method_path

      # Should see page header
      expect(page).to have_content("Payment")
      expect(page).to have_content("Manage your payment method")

      # Should see empty state
      expect(page).to have_content("No payment methods saved")
    end
  end

  context "when member has Omise customer but no cards" do
    let(:member) { create(:member) }

    before do
      # Create customer via Omise SDK (fake server will handle the request)
      customer = Omise::Customer.create(
        email: member.email,
        description: member.email
      )
      member.update(omise_customer_id: customer.id)
    end

    it "shows empty state" do
      visit account_payment_method_path

      # Should see empty state
      expect(page).to have_content("No payment methods saved")
    end
  end

  context "when member has single saved payment method" do
    let(:member) { create(:member) }

    before do
      # Create customer with card via Omise SDK
      customer = Omise::Customer.create(
        email: member.email,
        description: member.email,
        card: "tokn_test_#{SecureRandom.hex(11)}"
      )
      member.update(omise_customer_id: customer.id)
    end

    it "displays card details correctly" do
      visit account_payment_method_path

      # Should see page header
      expect(page).to have_content("Payment")
      expect(page).to have_content("Manage your payment method")

      # Should see card details
      expect(page).to have_content("Visa ending in 4242")
      expect(page).to have_content("Expires 12 / 2029")

      # Should see action buttons
      expect(page).to have_button("DELETE")
      expect(page).to have_button("EDIT")
    end
  end

  context "when member has multiple saved payment methods" do
    let(:member) { create(:member) }

    before do
      # Create customer with first card via Omise SDK
      customer = Omise::Customer.create(
        email: member.email,
        description: member.email,
        card: "tokn_test_#{SecureRandom.hex(11)}"
      )

      # Add more cards
      customer.update(card: "tokn_test_#{SecureRandom.hex(11)}")
      customer.update(card: "tokn_test_#{SecureRandom.hex(11)}")

      member.update(omise_customer_id: customer.id)
    end

    it "displays all cards with their details" do
      visit account_payment_method_path

      # Should see all three cards (fake server creates all as Visa 4242)
      expect(page).to have_content("Visa ending in 4242", count: 3)
      expect(page).to have_content("Expires 12 / 2029", count: 3)
    end

    it "shows DELETE and EDIT buttons for each card" do
      visit account_payment_method_path

      # Should have 3 DELETE buttons and 3 EDIT buttons
      expect(page).to have_button("DELETE", count: 3)
      expect(page).to have_button("EDIT", count: 3)
    end
  end

  context "when deleting a payment method" do
    let(:member) { create(:member) }

    before do
      # Create customer with card via Omise SDK
      customer = Omise::Customer.create(
        email: member.email,
        description: member.email,
        card: "tokn_test_#{SecureRandom.hex(11)}"
      )
      member.update(omise_customer_id: customer.id)
    end

    it "shows confirmation dialog and deletes successfully" do
      visit account_payment_method_path

      # Should see card
      expect(page).to have_content("Visa ending in 4242")

      # Click DELETE button - this should show browser confirmation
      # Accept the confirmation dialog
      accept_confirm do
        click_button "DELETE"
      end

      # Should see success message
      expect(page).to have_content("Payment method deleted successfully.")

      # Card should no longer be visible
      expect(page).not_to have_content("Visa ending in 4242")

      # Should see empty state
      expect(page).to have_content("No payment methods saved")
    end

    it "cancels deletion when user declines confirmation" do
      visit account_payment_method_path

      # Should see card
      expect(page).to have_content("Visa ending in 4242")

      # Click DELETE button but dismiss the confirmation
      dismiss_confirm do
        click_button "DELETE"
      end

      # Card should still be visible (deletion was cancelled)
      expect(page).to have_content("Visa ending in 4242")

      # Should NOT see success message
      expect(page).not_to have_content("Payment method deleted successfully.")
    end
  end

  context "when deleting one of multiple payment methods" do
    let(:member) { create(:member) }

    before do
      # Create customer with two cards via Omise SDK
      customer = Omise::Customer.create(
        email: member.email,
        description: member.email,
        card: "tokn_test_#{SecureRandom.hex(11)}"
      )

      # Add second card
      customer.update(card: "tokn_test_#{SecureRandom.hex(11)}")

      member.update(omise_customer_id: customer.id)
    end

    it "deletes only the selected card and keeps others" do
      visit account_payment_method_path

      # Should see both cards (both will be Visa 4242 from fake server)
      expect(page).to have_content("Visa ending in 4242", count: 2)

      # Delete the first card
      delete_buttons = page.all("button", text: "DELETE")
      accept_confirm do
        delete_buttons.first.click
      end

      # Should see success message
      expect(page).to have_content("Payment method deleted successfully.")

      # Should have one card remaining
      expect(page).to have_content("Visa ending in 4242", count: 1)

      # Should still have one DELETE button for remaining card
      expect(page).to have_button("DELETE", count: 1)
    end
  end
end
