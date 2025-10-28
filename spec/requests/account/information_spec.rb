require 'rails_helper'

RSpec.describe "Account::Information", type: :request do
  let(:member) { create(:member, first_name: "John", last_name: "Doe") }

  describe "GET /account/information" do
    context "when user is not authenticated" do
      it "redirects to sign in page" do
        get account_information_path
        expect(response).to redirect_to(new_member_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in member }

      it "returns successful response" do
        get account_information_path
        expect(response).to have_http_status(:ok)
      end

      it "displays user information" do
        get account_information_path
        expect(response.body).to include(member.email)
        expect(response.body).to include("John")
        expect(response.body).to include("Doe")
      end
    end
  end

  describe "GET /account/information/edit" do
    context "when user is not authenticated" do
      it "redirects to sign in page" do
        get edit_account_information_path
        expect(response).to redirect_to(new_member_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in member }

      it "returns successful response" do
        get edit_account_information_path
        expect(response).to have_http_status(:ok)
      end

      it "displays edit form" do
        get edit_account_information_path
        expect(response.body).to include("Edit Information")
      end
    end
  end

  describe "PATCH /account/information" do
    context "when user is not authenticated" do
      it "redirects to sign in page" do
        patch account_information_path, params: { member: { email: "new@example.com" } }
        expect(response).to redirect_to(new_member_session_path)
      end
    end

    context "when updating with valid params" do
      before { sign_in member }

      it "updates email successfully" do
        patch account_information_path, params: { member: { email: "newemail@example.com" } }

        expect(response).to redirect_to(account_information_path)
        expect(flash[:notice]).to eq("Account information updated successfully.")

        member.reload
        expect(member.email).to eq("newemail@example.com")
      end

      it "updates first name and last name" do
        patch account_information_path, params: {
          member: {
            first_name: "Jane",
            last_name: "Smith"
          }
        }

        expect(response).to redirect_to(account_information_path)
        expect(flash[:notice]).to eq("Account information updated successfully.")

        member.reload
        expect(member.first_name).to eq("Jane")
        expect(member.last_name).to eq("Smith")
      end

      it "updates all fields at once" do
        patch account_information_path, params: {
          member: {
            email: "updated@example.com",
            first_name: "Updated",
            last_name: "Name"
          }
        }

        expect(response).to redirect_to(account_information_path)

        member.reload
        expect(member.email).to eq("updated@example.com")
        expect(member.first_name).to eq("Updated")
        expect(member.last_name).to eq("Name")
      end

      it "allows clearing optional first name and last name" do
        patch account_information_path, params: {
          member: {
            first_name: "",
            last_name: ""
          }
        }

        expect(response).to redirect_to(account_information_path)

        member.reload
        expect(member.first_name).to be_blank
        expect(member.last_name).to be_blank
      end
    end

    context "when updating with invalid params" do
      before { sign_in member }

      it "renders edit form with invalid email format" do
        patch account_information_path, params: { member: { email: "invalid-email" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Edit Information")

        member.reload
        expect(member.email).not_to eq("invalid-email")
      end

      it "renders edit form with blank email" do
        original_email = member.email

        patch account_information_path, params: { member: { email: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Edit Information")

        member.reload
        expect(member.email).to eq(original_email)
      end

      it "does not persist invalid changes" do
        original_email = member.email

        patch account_information_path, params: { member: { email: "bad-email" } }

        member.reload
        expect(member.email).to eq(original_email)
      end
    end
  end
end
