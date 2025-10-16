require 'rails_helper'

describe "Checkout lists", js: true do
    let(:newspaper) { create(:newspaper) }
    let!(:one_month) { create(:one_month) }
    let!(:subscribe_monthly) { create(:subscribe_monthly) }

    it "show modal to sign in when payment" do
        visit newspaper_path(newspaper)
        click_button '1 Month Only'

        click_button 'Continue to Payment'

        expect(page).to have_content('Sign Up')
    end

  # TODO cannot alway open omise modal.
  #   context "user exists" do
  #     it "show modal omise when payment" do
  #         visit newspaper_path(newspaper)
  #         click_button '1 Month Only'

  #         click_button 'Continue to Payment'

  #         expect(page).to have_content('Omise')
  #     end
  #   end
end
