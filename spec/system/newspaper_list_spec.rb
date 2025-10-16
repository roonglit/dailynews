require 'rails_helper'

describe "Newspaper lists", js: true do
  before { @newspaper = create(:newspaper) }

  it "allows a visitor to view a newspaper details" do
    visit newspaper_path(@newspaper)

    expect(page).to have_content("Example Book")
    expect(page).to have_content("Description example")
  end
end
