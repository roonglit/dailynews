FactoryBot.define do
  factory :subscription do
    user
    start_date { Date.today }
    end_date { Date.today + 1.month }
  end
end
