require 'rails_helper'

RSpec.describe Guest, type: :model do
  let(:guest) { create(:guest) }

  describe "Guest model" do
    it "user is guest?" do
      expect(guest.guest?).to eq(true)
    end

    it "user is member?" do
      expect(guest.member?).to eq(false)
    end

    it "get email from user" do
      expect(guest.name).to eq("Guest")
    end

    it "Convert guest to member with email and password" do
      guest.convert_to_member!(email: "test@gmail.com", password: "Password123", password_confirmation: "Password123")
      expect(guest.type).to eq("Member")
      expect(guest.email).to eq("test@gmail.com")
    end
  end
end
