FactoryBot.define do
  factory :product do
    title { "Dailynews Newspaper" }
    description { "Dailynews newspaper" }
    sequence(:sku) { |n| "sku_#{n}" }

    factory :one_month do
      title { "1 Month Only" }
      amount { 100 }
      sku { "MEMBERSHIP_ONE_MONTH" }
    end

    factory :subscribe_monthly do
      title { "Subscribe Monthly" }
      amount { 80 }
      sku { "MEMBERSHIP_MONTHLY_SUBSCRIPTION" }
    end
  end
end
