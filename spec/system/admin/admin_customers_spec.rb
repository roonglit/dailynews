require 'rails_helper'

RSpec.configure do |config|
  config.before(:each) do
    FactoryBot.rewind_sequences
  end

  describe "Admin Subscriptions" do
    context "when admin click Subscriptions button" do
      before { @subscriptions = create_list(:subscription, 1) }

      it "admin user can view all Subscriptions" do
        login_as_admin

        click_link_or_button "Subscriptions"

        expect(page).to have_current_path(admin_subscriptions_path)
        expect(page).to have_link("Subscriptions")
        expect(page).to have_content("test1@example.com")
      end

      it "when admin press View Customer should navigate to customer info page" do
        login_as_admin

        click_link_or_button "Subscriptions"
        click_link_or_button "View Customer"

        expect(page).to have_current_path(admin_customer_path(1))
        expect(page).to have_content("Basic Information")
      end

      it "given empty Subscriptions, admin should not see any subscriptions" do
        Subscription.destroy_all
        login_as_admin

        click_link_or_button "Subscriptions"

        expect(page).to have_current_path(admin_subscriptions_path)
        expect(page).to have_link("Subscriptions")
        expect(page).not_to have_content("test1@example.com")
      end
    end
  end
end
