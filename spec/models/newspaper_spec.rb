require 'rails_helper'

RSpec.describe Newspaper, type: :model do
  let!(:newspaper1) { create(:newspaper, created_at: Date.today) }
  let!(:newspaper2) { create(:newspaper, created_at: Date.tomorrow) }

  it "newspaper can order by created_at date" do
    assert_equal Newspaper.order_by_created_at, [ newspaper1, newspaper2 ]
  end
end
