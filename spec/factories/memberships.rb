FactoryBot.define do
  factory :membership do
    user

    trait :one_day do
      start_date { Date.today }
      end_date { Date.today + 1 }
    end

    trait :before_one_month do
      start_date { Date.today - 60 }
      end_date { Date.today - 30 }
    end

    trait :one_month_ago do
      start_date { Date.today + 30 }
      end_date { Date.today + 60 }
    end
  end
end
