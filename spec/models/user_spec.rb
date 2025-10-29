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

    context "query search exists" do
      before { create(:user, first_name: "A", last_name: "a") }
      it "should be return user A when query search is a or A" do
        expect(User.search("a")).to eq(User.where(first_name: "A"))
      end
    end

    it "should be return all user when not have query for search" do
      expect(User.search(nil)).to eq(User.all)
    end
  end
end
