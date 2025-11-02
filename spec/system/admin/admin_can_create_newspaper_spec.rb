require 'rails_helper'

describe "Admin Can Create Newspaper" do
  before { @newspaper = create(:newspaper) }

  it "navigates to new newspaper form" do
    login_as_admin
    click_link_or_button "Newspapers"
    click_link_or_button "New newspaper"

    expect(page).to have_current_path(new_admin_newspaper_path)
    expect(page).to have_content("New Newspaper")
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
