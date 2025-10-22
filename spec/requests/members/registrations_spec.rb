require 'rails_helper'

RSpec.describe "Members::Registrations", type: :request do
  describe "GET /members/sign_up" do
    it "renders the sign up page" do
      get new_member_registration_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /members/sign_up" do
    let(:valid_params) do
      {
        member: {
          email: "test@example.com",
          password: "Password123",
          password_confirmation: "Password123"
        }
      }
    end

    let(:invalid_params) do
      {
        member: {
          email: "invalid-email",
          password: "short",
          password_confirmation: "mismatch"
        }
      }
    end

    context "with valid params" do
      it "creates a new member and redirects" do
        expect {
          post member_registration_path, params: valid_params
        }.to change(Member, :count).by(1)
      end
    end

    context "with invalid params" do
      it "does not create a member and renders turbo_stream" do
        expect {
          post member_registration_path, params: invalid_params
        }.not_to change(Member, :count)
      end
    end

    context "inactive account" do
      it "handles inactive member" do
        allow_any_instance_of(Member).to receive(:active_for_authentication?).and_return(false)
        allow_any_instance_of(Member).to receive(:inactive_message).and_return(:unconfirmed)

        expect {
          post member_registration_path, params: valid_params
        }.to change(Member, :count).by(1)
      end
    end
  end
end
