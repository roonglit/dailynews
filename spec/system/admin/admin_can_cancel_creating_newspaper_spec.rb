require 'rails_helper'

describe "Admin Can Cancel Creating Newspaper" do
  it "cancels creating a new newspaper" do
    newspaper = create(:newspaper)
    login_as_admin

    expect {
      click_link_or_button "Newspapers"
      click_link_or_button "New newspaper"
      click_link_or_button "Cancel"
    }.not_to change(Newspaper, :count)

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content("Newspapers")
  end
end
