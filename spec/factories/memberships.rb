FactoryBot.define do
  factory :membership do
    user
    start_date { Date.today }
    end_date { Date.today + 1.month }
  end
end
