require 'rails_helper'

describe "Library", js: true do
  let!(:user) { create(:member) }

  before { login_as_user(user) }
  it "if the user is not logged in, the library will be empty." do
    visit library_path

    expect(page).to have_content("No newspapers available")
    expect(page).to have_content("Check back later for new additions to our library.")
  end

  context "there are newspapers but no membership" do
    let!(:newspaper) { create(:newspaper) }

    it "there is no membership, the library will be empty" do
      visit library_path

      expect(page).to have_content("No newspapers available")
      expect(page).to have_content("Check back later for new additions to our library.")
    end
  end

  context "there are newspapers and membership" do
    let!(:newspaper) { create(:newspaper) }
    before { create(:membership, user: user) }

    it "the library will be visible" do
      visit library_path

      expect(page).to have_content("Example Book")
      expect(page).not_to have_content("No newspapers available")
      expect(page).not_to have_content("Check back later for new additions to our library.")
    end
  end
end
