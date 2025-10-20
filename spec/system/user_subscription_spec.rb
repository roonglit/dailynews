require 'rails_helper'

describe "User interactions with newspaper subscriptions", js: true do
  context "when user is a guest" do
    let(:newspaper) { create(:newspaper) }
    let!(:subscribe_monthly_product) { create(:subscribe_monthly) }

    it "display authentication modal when guest clicks continuing to payment" do
      visit root_path
      click_button "สมัครสมาชิก"

      click_link_or_button "Continue to Payment"

      expect(page).to have_content("Sign Up")
    end
  end

  context "when user is a member" do
    let(:newspaper) { create(:newspaper) }
    let!(:subscribe_monthly_product) { create(:subscribe_monthly) }

    before { login_as_user }

    it "allows member to add product and redirects to checkout" do
      visit root_path
      click_button "สมัครสมาชิก"

      expect(page).to have_content("Product added to cart")
    end

    # it "display omise modal when guest clicks continuing to payment" do
    #   visit root_path
    #   click_button "สมัครสมาชิก"

    #   click_link_or_button "Continue to Payment"

    #   expect(page).to have_content("")
    # end

    it "[Test] allows member to grants a one-month membership when member clicks free subscription" do
      visit root_path
      click_button "สมัครสมาชิก"

      accept_confirm "Skip payment and grant free membership?" do
        click_button "Grant Free Membership (Testing)"
      end

      expect(page).to have_content("Transaction Completed")
    end
  end
end
