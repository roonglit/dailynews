FactoryBot.define do
  factory :subscription do
    association :member
    start_date { Date.today }
    end_date { Date.today + 1.month }
  end
end
