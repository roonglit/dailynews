require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User model" do
    context "user is member" do
      it "requires email" do
        member.email = nil
        expect(member).not_to be_valid
        expect(member.errors[:email]).to include("can't be blank")
      end

      it "requires password" do
        member.password = nil
        expect(member).not_to be_valid
        expect(member.errors[:password]).to include("can't be blank")
      end
    end

    context "user is guest" do
      it "does not require email" do
        guest.email = nil
        expect(guest).to be_valid
      end

      it "does not require password" do
        guest.password = nil
        expect(guest).to be_valid
      end
    end

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
