require 'rails_helper'

describe "Sign Up" do
  # before do
  #   driven_by(:selenium_chrome)
  # end

  it "should be allows a user to register" do
    visit root_path

    find("[data-test-id='open-sign-up']").click

    expect(page).to have_selector("[data-test-id='sign-up-modal']")

    find("[data-test-id='sign-up-email']").fill_in with: "test@example.com"
    find("[data-test-id='sign-up-password']").fill_in with: "123456"
    find("[data-test-id='sign-up-confirm-password']").fill_in with: "123456"

    find("[data-test-id='sign-up-submit']").click

    expect(page).to have_selector("[data-test-id='user-avatar']")
  end

  it "should be switch to login modal when clicks Sign in here" do
    visit root_path

    find("[data-test-id='open-sign-up']").click

    find("[data-test-id='switch-to-sign-in']").click

    expect(page).to have_selector("[data-test-id='sign-in-modal']")
    expect(page).not_to have_selector("[data-test-id='sign-up-modal']")
  end
end
