require 'rails_helper'

describe "Newspaper Details" do
  let!(:newspaper) { create(:newspaper) }

  it "allows a visitor to view a newspaper's details" do
    visit newspaper_path(newspaper)

    expect(page).to have_content("Example Book")
    expect(page).to have_content("Description example")
  end
end
