require 'rails_helper'

describe "Admin Can View Newspaper Details" do
  before { @newspaper = create(:newspaper) }

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
end
