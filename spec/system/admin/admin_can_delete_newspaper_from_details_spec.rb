require 'rails_helper'

describe "Admin Can Delete Newspaper From Details" do
  it "deletes newspaper from detail page" do
    newspaper = create(:newspaper)
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.show-icon').click
      click_link_or_button "Delete"
    }.to change(Newspaper, :count).from(1).to(0)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).not_to have_content(newspaper.title)
  end
end
