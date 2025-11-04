require 'rails_helper'

describe "Library access", js: true do
  let(:member) { create(:member) }

  before do
    login_as_user(member)
  end

  context "when member has no subscription" do
    it "shows empty library message" do
      visit library_path

      expect(page).to have_content("Please subscribe first.")
      expect(page).to have_current_path(root_path)
    end
  end

  context "when member has active subscription" do
    let!(:subscription) do
      create(:subscription,
        member: member,
        start_date: Date.today,
        end_date: Date.today + 30.days,
        auto_renew: true)
    end

    it "member can read newspaper" do
      newspaper1 = create(:newspaper,
        title: "Daily News Today",
        published_at: Date.today)

        visit library_path

        expect(page).to have_content("Daily News Today")

        click_link_or_button "View Details"
        expect(page).to have_css(".back-to-library")
    end

    it "member back to library page in newspaper flip book" do
      newspaper1 = create(:newspaper,
        title: "Daily News Today",
        published_at: Date.today)

        visit library_path

        click_link_or_button "View Details"
        find(".back-to-library").trigger("click")

        expect(page).to have_content("Daily News Today")
    end

    it "shows newspapers within subscription period" do
      # Create newspapers within subscription period
      newspaper1 = create(:newspaper,
        title: "Daily News Today",
        published_at: Date.today)
      newspaper2 = create(:newspaper,
        title: "Daily News Tomorrow",
        published_at: Date.today + 1.day)

      visit library_path

      # Should see newspapers
      expect(page).to have_content("Daily News Today")
      expect(page).to have_content("Daily News Tomorrow")
      expect(page).not_to have_content("No newspapers available")
    end

    it "does not show newspapers outside subscription period" do
      # Create newspaper before subscription starts
      create(:newspaper,
        title: "Old News",
        published_at: Date.today - 10.days)

      # Create newspaper after subscription ends
      create(:newspaper,
        title: "Future News",
        published_at: Date.today + 60.days)

      # Create newspaper within subscription
      create(:newspaper,
        title: "Current News",
        published_at: Date.today + 5.days)

      visit library_path

      # Should only see newspaper within subscription
      expect(page).to have_content("Current News")
      expect(page).not_to have_content("Old News")
      expect(page).not_to have_content("Future News")
    end
  end

  context "when member has expired subscription" do
    let!(:subscription) do
      create(:subscription,
        member: member,
        start_date: 2.months.ago,
        end_date: 1.month.ago,
        auto_renew: false)
    end

    it "can still access newspapers from expired subscription period" do
      # Create newspaper within the old subscription period
      newspaper = create(:newspaper,
        title: "Old Subscription News",
        published_at: 6.weeks.ago)

      visit library_path

      # Should still see newspapers from expired period
      expect(page).to have_content("Old Subscription News")
      expect(page).not_to have_content("No newspapers available")
    end

    it "does not show newspapers outside expired subscription period" do
      # Create newspaper from expired period
      create(:newspaper,
        title: "Old News",
        published_at: 6.weeks.ago)

      # Create newspaper from today (outside expired subscription)
      create(:newspaper,
        title: "Today's News",
        published_at: Date.today)

      visit library_path

      # Should only see newspaper from expired period
      expect(page).to have_content("Old News")
      expect(page).not_to have_content("Today's News")
    end
  end

  context "when member has continuous subscription" do
    let!(:subscription) do
      create(:subscription,
        member: member,
        start_date: Date.new(2025, 7, 1),
        end_date: Date.new(2025, 10, 31))
    end

    it "shows newspapers throughout subscription period" do
      # Create newspapers at different times in subscription
      july_newspaper = create(:newspaper,
        title: "July News",
        published_at: Date.new(2025, 7, 15))

      october_newspaper = create(:newspaper,
        title: "October News",
        published_at: Date.new(2025, 10, 15))

      # Create newspaper before subscription
      before_newspaper = create(:newspaper,
        title: "June News",
        published_at: Date.new(2025, 6, 15))

      # Create newspaper after subscription
      after_newspaper = create(:newspaper,
        title: "November News",
        published_at: Date.new(2025, 11, 15))

      visit library_path

      # Should see newspapers within subscription period
      expect(page).to have_content("July News")
      expect(page).to have_content("October News")

      # Should NOT see newspapers outside subscription period
      expect(page).not_to have_content("June News")
      expect(page).not_to have_content("November News")
    end
  end

  context "month filtering" do
    let!(:subscription) do
      create(:subscription,
        member: member,
        start_date: Date.new(2025, 1, 1),
        end_date: Date.new(2025, 3, 31))
    end

    before do
      # Create newspapers in different months
      create(:newspaper,
        title: "January News",
        published_at: Date.new(2025, 1, 15))
      create(:newspaper,
        title: "February News",
        published_at: Date.new(2025, 2, 15))
      create(:newspaper,
        title: "March News",
        published_at: Date.new(2025, 3, 15))
    end

    it "shows all newspapers when no month filter is selected" do
      visit library_path

      expect(page).to have_content("January News")
      expect(page).to have_content("February News")
      expect(page).to have_content("March News")
    end

    it "filters newspapers by selected month" do
      visit library_path

      # Select February from dropdown
      select "February", from: "month"

      # Should only see February newspaper
      expect(page).to have_content("February News")
      expect(page).not_to have_content("January News")
      expect(page).not_to have_content("March News")
    end
  end

  it "not visit to library when not have any subscription" do
    visit library_path

    expect(page).to have_content("Please subscribe first.")
  end
end
