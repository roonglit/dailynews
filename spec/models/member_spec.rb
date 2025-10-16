require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:member) { create(:member) }

  describe "Member model" do
    it "user is guest?" do
      expect(member.guest?).to eq(false)
    end

    it "user is member?" do
      expect(member.member?).to eq(true)
    end

    it "get email from user" do
      expect(member.name).to eq(member.email)
    end
  end
end
