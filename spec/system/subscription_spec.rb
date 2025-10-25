require 'rails_helper'

describe "User interactions with newspaper subscriptions", js: true do
  let!(:subscribe_monthly_product) { create(:monthly_subscription_product) }

  context "when user is a guest" do
    let(:newspaper) { create(:newspaper) }

    it "display authentication modal when guest clicks continuing to payment" do
      visit root_path
      click_button "subscribe"

      expect(page).to have_content("Product added to cart")
      expect(page).to have_content("Subscribe Monthly")
      expect(page).to have_content("80 Baht")

      click_link_or_button "Continue to Payment"

      expect(page).to have_content("Sign Up")
    end
  end

  context "when user is a member" do
    let(:newspaper) { create(:newspaper) }

    before { login_as_user }

    it "allows member to add product and redirects to checkout" do
      visit root_path
      click_button "subscribe"

      expect(page).to have_content("Product added to cart")
      expect(page).to have_content("Subscribe Monthly")
      expect(page).to have_content("80 Baht")
    end

    # [TODO] : Wait for omise
    # it "display omise modal when guest clicks continuing to payment" do
    #   visit root_path
    #   click_button "สมัครสมาชิก"

    #   click_link_or_button "Continue to Payment"

    #   expect(page).to have_content("")
    # end
  end
end
