require 'rails_helper'

describe "Admin Can View Newspapers List" do
  it "navigates to manage newspapers page and displays newspapers" do
    newspaper = create(:newspaper)
    login_as_admin
    click_link_or_button "Newspapers"

    expect(page).to have_current_path(admin_newspapers_path)
    expect(page).to have_content(newspaper.title)
  end
end
