require 'rails_helper'

describe "Admin Can Delete Newspaper From List" do
  it "deletes a newspaper from the list" do
    newspaper = create(:newspaper)
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.trash-icon').click
    }.to change(Newspaper, :count).from(1).to(0)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).not_to have_content(newspaper.title)
  end
end
