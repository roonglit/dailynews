require 'rails_helper'

describe "User interactions with newspaper subscriptions", js: true do
  context "when user is a guest" do
    let(:newspaper) { create(:newspaper) }
    let!(:one_month_product) { create(:one_month) }
    let!(:subscribe_monthly_product) { create(:subscribe_monthly) }

    it "allows guest to add product to cart and view checkout page" do
      visit newspaper_path(newspaper)

      click_button "1 Month Only"

      expect(page).to have_content("Product added to cart")
    end

    it "display authentication modal when guest clicks continuing to payment" do
      visit newspaper_path(newspaper)
      click_button "1 Month Only"

      click_link_or_button "Continue to Payment"

      expect(page).to have_content("Sign Up")
    end
  end

  context "when user is a member" do
    let(:newspaper) { create(:newspaper) }
    let!(:one_month_product) { create(:one_month) }
    let!(:subscribe_monthly_product) { create(:subscribe_monthly) }

    before { login_as_user }

    it "allows member to add product and redirects to checkout" do
      visit newspaper_path(newspaper)

      click_button "Subscribe Monthly"

      expect(page).to have_content("Product added to cart")
    end

    # it "display omise modal when guest clicks continuing to payment" do
    #   visit newspaper_path(newspaper)
    #   click_button "1 Month Only"

    #   click_link_or_button "Continue to Payment"

    #   expect(page).to have_content("")
    # end

    it "[Test] allows member to grants a one-month membership when member clicks free subscription" do
      visit newspaper_path(newspaper)
      click_button "Subscribe Monthly"

      accept_confirm "Skip payment and grant free membership?" do
        click_button "Grant Free Membership (Testing)"
      end

      expect(page).to have_content("Transaction Completed")
    end
  end
end
