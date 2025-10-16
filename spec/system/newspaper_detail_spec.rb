require 'rails_helper'

describe "Newspaper details", js: true do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:member) }
  let(:newspaper) { create(:newspaper) }
  let!(:one_month_product) { create(:one_month) }
  let!(:subscribe_monthly_product) { create(:subscribe_monthly) }

  context "when user has a valid membership covering the newspaper publish date" do
    before do
      travel_to(Date.today) do
        create(:membership, user: user)
      end
    end

    it "allows the user to read the newspaper" do
      login_as_user(user)
      visit newspaper_path(newspaper)

      expect(page).to have_link("Read")
      expect(page).not_to have_button("1 Month Only")
      expect(page).not_to have_button("Subscribe Monthly")
    end
  end

  context "when user has a membership that expired before newspaper published" do
    before do
      travel_to(1.month.ago) do
        create(:membership, user: user)
      end
    end

    it "allows the user to subscribe" do
      login_as_user
      visit newspaper_path(newspaper)

      expect(page).to have_button("1 Month Only")
      expect(page).to have_button("Subscribe Monthly")
      expect(page).not_to have_link("Read")
    end

    it "when user clicks 1 Month Only type can redirect to payment page and displays it correctly" do
      visit newspaper_path(newspaper)

      click_button "1 Month Only"

      expect(page).to have_content("Product added to cart")
      expect(page).to have_content("1 Month Only")
    end

    it "when user clicks Subscribe Monthly type can redirect to payment page and displays it correctly" do
      visit newspaper_path(newspaper)

      click_button "Subscribe Monthly"

      expect(page).to have_content("Product added to cart")
      expect(page).to have_content("Subscribe Monthly")
    end
  end

  context "when user has a membership that starts after newspaper published" do
    before do
      travel_to(1.month.from_now) do
        create(:membership, user: user)
      end
    end

    it "allows the user to subscribe" do
      login_as_user
      visit newspaper_path(newspaper)

      expect(page).to have_button("1 Month Only")
      expect(page).to have_button("Subscribe Monthly")
      expect(page).not_to have_link("Read")
    end
  end

  context "when user has no memberships" do
    it "allows the user to subscribe" do
      login_as_user
      visit newspaper_path(newspaper)

      expect(page).to have_button("1 Month Only")
      expect(page).to have_button("Subscribe Monthly")
      expect(page).not_to have_link("Read")
    end
  end
end
