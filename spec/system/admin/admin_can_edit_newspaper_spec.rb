require 'rails_helper'

describe "Admin Can Edit Newspaper" do
  before { @newspaper = create(:newspaper) }

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
end
