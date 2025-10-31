require 'rails_helper'

describe "Admin Newspapers" do
  before { @newspaper = create(:newspaper) }

  it "navigates to manage newspapers page" do
    login_as_admin
    click_link_or_button "Newspapers"

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content(@newspaper.title)
  end

  it "deletes a newspaper from the list" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.trash-icon').click
    }.to change(Newspaper, :count).from(1).to(0)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).not_to have_content(@newspaper.title)
  end

  it "navigates to newspaper detail page" do
    login_as_admin
    click_link_or_button "Newspapers"
    find('.show-icon').click

    expect(page).to have_current_path(admin_newspaper_path(@newspaper))
    expect(page).to have_content(@newspaper.title)
  end

  it "navigates back from newspaper detail page" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.show-icon').click
      click_link_or_button "Back to list"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content(@newspaper.title)
  end

  it "deletes newspaper from detail page" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.show-icon').click
      click_link_or_button "Delete"
    }.to change(Newspaper, :count).from(1).to(0)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).not_to have_content(@newspaper.title)
  end

  it "navigates to edit newspaper from detail page" do
    login_as_admin
    click_link_or_button "Newspapers"
    find('.show-icon').click
    click_link_or_button "Edit"

    expect(page).to have_current_path(edit_admin_newspaper_path(@newspaper))
    expect(page).to have_content("Edit Newspaper")
  end

  it "navigates to edit newspaper from list" do
    login_as_admin
    click_link_or_button "Newspapers"
    find('.pencil-icon').click

    expected_published_date = @newspaper.published_at.strftime("%Y-%m-%d")

    expect(page).to have_current_path(edit_admin_newspaper_path(@newspaper))
    expect(page).to have_content("Edit Newspaper")
    expect(page).to have_field("newspaper_title", with: @newspaper.title)
    expect(page).to have_field("newspaper_description", with: @newspaper.description)
    expect(page).to have_field("newspaper_published_at", with: expected_published_date)
  end

  it "cancels editing a newspaper" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.pencil-icon').click
      click_link_or_button "Cancel"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content("Newspapers")
  end

  it "edits newspaper title and saves changes" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.pencil-icon').click
      fill_in 'newspaper_title', with: "Updated Title"
      click_link_or_button "Save"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspaper_path(@newspaper))
    expect(page).to have_content("Updated Title")
  end

  it "navigates to new newspaper form" do
    login_as_admin
    click_link_or_button "Newspapers"
    click_link_or_button "New newspaper"

    expect(page).to have_current_path(new_admin_newspaper_path)
    expect(page).to have_content("New Newspaper")
  end

  it "cancels creating a new newspaper" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      click_link_or_button "New newspaper"
      click_link_or_button "Cancel"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content("Newspapers")
  end

  it "creates a new newspaper" do
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      click_link_or_button "New newspaper"
      fill_in 'newspaper_title', with: "New Newspaper Title"
      click_link_or_button "Create Newspaper"
    }.to change(Newspaper, :count).from(1).to(2)

    new_newspaper = Newspaper.last
    expect(page).to have_current_path(admin_newspaper_path(new_newspaper))
    expect(page).to have_content("New Newspaper Title")
  end
end
