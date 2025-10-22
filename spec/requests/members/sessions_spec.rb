require 'rails_helper'

RSpec.describe "Members::Sessions", type: :request do
  let(:member) { create(:member) }

  it "renders the login page" do
    get new_member_session_path
    expect(response).to have_http_status(:ok)
  end

  it "signs in a member" do
    post member_session_path, params: { member: { email: member.email, password: member.password } }
    expect(response).to redirect_to(root_path)
  end

  it "signs out a member" do
    sign_in member
    delete destroy_member_session_path
    expect(response).to redirect_to(root_path)
  end
end
