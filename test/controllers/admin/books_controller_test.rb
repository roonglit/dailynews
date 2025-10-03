require "test_helper"

class Admin::BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_book = admin_books(:one)
  end

  test "should get index" do
    get admin_books_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_book_url
    assert_response :success
  end

  test "should create admin_book" do
    assert_difference("Admin::Book.count") do
      post admin_books_url, params: { admin_book: {} }
    end

    assert_redirected_to admin_book_url(Admin::Book.last)
  end

  test "should show admin_book" do
    get admin_book_url(@admin_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_book_url(@admin_book)
    assert_response :success
  end

  test "should update admin_book" do
    patch admin_book_url(@admin_book), params: { admin_book: {} }
    assert_redirected_to admin_book_url(@admin_book)
  end

  test "should destroy admin_book" do
    assert_difference("Admin::Book.count", -1) do
      delete admin_book_url(@admin_book)
    end

    assert_redirected_to admin_books_url
  end
end
