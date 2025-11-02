require 'rails_helper'

describe "Admin can manage newspapers", js: true do
  context "when admin is signed in and newspapers exist" do
    let!(:newspaper) { create(:newspaper) }

    before do
      login_as_admin
    end

    it "navigates to manage newspapers page and displays newspapers" do
      click_link_or_button "Newspapers"

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).to have_content(newspaper.title)
    end

    it "navigates to newspaper detail page" do
      click_link_or_button "Newspapers"
      find('.show-icon').click

      expect(page).to have_current_path(admin_newspaper_path(newspaper))
      expect(page).to have_content(newspaper.title)
    end

    it "navigates back from newspaper detail page" do
      expect {
        click_link_or_button "Newspapers"
        find('.show-icon').click
        click_link_or_button "Back to list"
      }.not_to change(Newspaper, :count)

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).to have_content(newspaper.title)
    end
  end

  context "when admin is signed in with existing newspaper" do
    before do
      @newspaper = create(:newspaper)
      login_as_admin
    end

    it "navigates to new newspaper form" do
      click_link_or_button "Newspapers"
      click_link_or_button "New newspaper"

      expect(page).to have_current_path(new_admin_newspaper_path)
      expect(page).to have_content("New Newspaper")
    end

    it "creates a new newspaper" do
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

    it "cancels creating a new newspaper" do
      expect {
        click_link_or_button "Newspapers"
        click_link_or_button "New newspaper"
        click_link_or_button "Cancel"
      }.not_to change(Newspaper, :count)

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).to have_content("Newspapers")
    end
  end

  context "when admin is signed in and editing existing newspaper" do
    before do
      @newspaper = create(:newspaper)
      login_as_admin
    end

    it "navigates to edit newspaper from detail page" do
      click_link_or_button "Newspapers"
      find('.show-icon').click
      click_link_or_button "Edit"

      expect(page).to have_current_path(edit_admin_newspaper_path(@newspaper))
      expect(page).to have_content("Edit Newspaper")
    end

    it "navigates to edit newspaper from list" do
      click_link_or_button "Newspapers"
      find('.pencil-icon').click

      expected_published_date = @newspaper.published_at.strftime("%Y-%m-%d")

      expect(page).to have_current_path(edit_admin_newspaper_path(@newspaper))
      expect(page).to have_content("Edit Newspaper")
      expect(page).to have_field("newspaper_title", with: @newspaper.title)
      expect(page).to have_field("newspaper_description", with: @newspaper.description)
      expect(page).to have_field("newspaper_published_at", with: expected_published_date)
    end

    it "edits newspaper title and saves changes" do
      expect {
        click_link_or_button "Newspapers"
        find('.pencil-icon').click
        fill_in 'newspaper_title', with: "Updated Title"
        click_link_or_button "Save"
      }.not_to change(Newspaper, :count)

      expect(page).to have_current_path(admin_newspaper_path(@newspaper))
      expect(page).to have_content("Updated Title")
    end

    it "cancels editing a newspaper" do
      expect {
        click_link_or_button "Newspapers"
        find('.pencil-icon').click
        click_link_or_button "Cancel"
      }.not_to change(Newspaper, :count)

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).to have_content("Newspapers")
    end
  end

  context "when admin is signed in and newspaper exists to delete" do
    let!(:newspaper) { create(:newspaper) }

    before do
      login_as_admin
    end

    it "deletes newspaper from detail page" do
      expect {
        click_link_or_button "Newspapers"
        find('.show-icon').click
        click_link_or_button "Delete"
      }.to change(Newspaper, :count).from(1).to(0)

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).not_to have_content(newspaper.title)
    end

    it "deletes a newspaper from the list" do
      expect {
        click_link_or_button "Newspapers"
        find('.trash-icon').click
      }.to change(Newspaper, :count).from(1).to(0)

      expect(page).to have_current_path(admin_newspapers_path)
      expect(page).not_to have_content(newspaper.title)
    end
  end
end
