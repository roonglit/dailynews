FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    type { "Member" }

    factory :member, class: "Member" do
      type { "Member" }
    end

    factory :guest, class: "Guest" do
      type { "Guest" }
      email { nil }
      password { nil }
      password_confirmation { nil }
    end

    trait :with_one_day_membership do
      after(:create) do |user|
        create(:membership, :one_day, user: user)
      end
    end

    trait :with_before_one_month_membership do
      after(:create) do |user|
        create(:membership, :before_one_month, user: user)
      end
    end

    trait :with_one_month_ago_membership do
      after(:create) do |user|
        create(:membership, :one_month_ago, user: user)
      end
    end
  end
end
