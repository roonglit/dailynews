require "application_system_test_case"

class Admin::BooksTest < ApplicationSystemTestCase
  setup do
    @admin_book = admin_books(:one)
  end

  test "visiting the index" do
    visit admin_books_url
    assert_selector "h1", text: "Books"
  end

  test "should create book" do
    visit admin_books_url
    click_on "New book"

    click_on "Create Book"

    assert_text "Book was successfully created"
    click_on "Back"
  end

  test "should update Book" do
    visit admin_book_url(@admin_book)
    click_on "Edit this book", match: :first

    click_on "Update Book"

    assert_text "Book was successfully updated"
    click_on "Back"
  end

  test "should destroy Book" do
    visit admin_book_url(@admin_book)
    click_on "Destroy this book", match: :first

    assert_text "Book was successfully destroyed"
  end
end
