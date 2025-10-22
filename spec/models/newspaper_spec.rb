require 'rails_helper'

RSpec.describe Newspaper, type: :model do
  let(:newspaper1) { create(:newspaper, created_at: Date.today) }
  let(:newspaper2) { create(:newspaper, created_at: Date.tomorrow) }

  it "newspaper can order by created_at date" do
    assert_equal Newspaper.order_by_created_at, [ newspaper1, newspaper2 ]
  end

  it "filter newspapers by month" do
    newspaper_jan = create(:newspaper, published_at: Date.new(Time.zone.today.year, 1, 1))
    newspaper_feb = create(:newspaper, published_at: Date.new(Time.zone.today.year, 2, 1))

    january_newspapers = Newspaper.filter_by_month("1", Time.zone.today.year)
    february_newspapers = Newspaper.filter_by_month("2", Time.zone.today.year)
    all_newspapers = Newspaper.filter_by_month(nil)

    expect(january_newspapers).to eq([ newspaper_jan ])
    expect(january_newspapers).not_to eq([ newspaper_feb ])

    expect(february_newspapers).to eq([ newspaper_feb ])
    expect(february_newspapers).not_to eq([ newspaper_jan ])

    expect(all_newspapers).to eq [ newspaper_jan, newspaper_feb ]
  end
end
