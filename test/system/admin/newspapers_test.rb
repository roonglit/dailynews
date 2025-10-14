require "application_system_test_case"

class Admin::NewspapersTest < ApplicationSystemTestCase
  setup do
    @admin_newspaper = admin_newspapers(:one)
  end

  test "visiting the index" do
    visit admin_newspapers_url
    assert_selector "h1", text: "newspapers"
  end

  test "should create newspaper" do
    visit admin_newspapers_url
    click_on "New newspaper"

    click_on "Create newspaper"

    assert_text "newspaper was successfully created"
    click_on "Back"
  end

  test "should update newspaper" do
    visit admin_newspaper_url(@admin_newspaper)
    click_on "Edit this newspaper", match: :first

    click_on "Update newspaper"

    assert_text "newspaper was successfully updated"
    click_on "Back"
  end

  test "should destroy newspaper" do
    visit admin_newspaper_url(@admin_newspaper)
    click_on "Destroy this newspaper", match: :first

    assert_text "newspaper was successfully destroyed"
  end
end
