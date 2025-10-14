require "test_helper"

class Admin::NewspapersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_newspaper = admin_newspapers(:one)
  end

  test "should get index" do
    get admin_newspapers_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_newspaper_url
    assert_response :success
  end

  test "should create admin_newspaper" do
    assert_difference("Admin::Newspaper.count") do
      post admin_newspapers_url, params: { admin_newspaper: {} }
    end

    assert_redirected_to admin_newspaper_url(Admin.newspaper.last)
  end

  test "should show admin_newspaper" do
    get admin_newspaper_url(@admin_newspaper)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_newspaper_url(@admin_newspaper)
    assert_response :success
  end

  test "should update admin_newspaper" do
    patch admin_newspaper_url(@admin_newspaper), params: { admin_newspaper: {} }
    assert_redirected_to admin_newspaper_url(@admin_newspaper)
  end

  test "should destroy admin_newspaper" do
    assert_difference("Admin::Newspaper.count", -1) do
      delete admin_newspaper_url(@admin_newspaper)
    end

    assert_redirected_to admin_newspapers_url
  end
end
