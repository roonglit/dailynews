require 'rails_helper'

describe "Admin Can Cancel Editing Newspaper" do
  it "cancels editing a newspaper" do
    newspaper = create(:newspaper)
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      find('.pencil-icon').click
      click_link_or_button "Cancel"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content("Newspapers")
  end
end
