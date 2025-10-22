require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User model" do
    it "user is guest?" do
      @user = create(:user)
      expect(@user.guest?).to eq(false)
    end

    it "user is member?" do
      @user = create(:user)
      expect(@user.member?).to eq(false)
    end

    it "get email from user" do
      @user = create(:user, email: "test@gmail.com")
      expect(@user.name).to eq("test@gmail.com")
    end

    it "get default name from user when email is nil" do
      @user = create(:user, email: nil)
      expect(@user.name).to eq("User")
    end
  end
end
