require 'rails_helper'

describe "Newspaper details" do
  include ActiveSupport::Testing::TimeHelpers

  context "user have one day memberships" do
    before do
      travel_to(Date.today) do
        @user = create(:member)
        create(:membership, user: @user)
      end
    end
    it "" do
      @user
    end
  end
end
