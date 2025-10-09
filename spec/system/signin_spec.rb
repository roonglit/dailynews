require 'rails_helper'

describe "Sign In" do
  let!(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome)
  end

  it "should be allows a user to login" do
    visit root_path

    find("[data-test-id='open-sign-up']").click

    find("[data-test-id='switch-to-sign-in']").click

    find("[data-test-id='sign-in-email']").fill_in with: "test@example.com"
    find("[data-test-id='sign-in-password']").fill_in with: "123456"

    find("[data-test-id='sign-in-submit']").click

    expect(page).to have_selector("[data-test-id='user-avatar']")
  end

  it "should be switch to register modal when clicks Register here" do
    visit root_path

    find("[data-test-id='open-sign-up']").click

    find("[data-test-id='switch-to-sign-in']").click
    find("[data-test-id='switch-to-sign-up']").click

    expect(page).to have_selector("[data-test-id='sign-up-modal']")
    expect(page).not_to have_selector("[data-test-id='sign-in-modal']")
  end
end
