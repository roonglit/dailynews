FactoryBot.define do
  factory :product do
    title { "Dailynews Newspaper" }
    description { "Dailynews newspaper" }
    sequence(:sku) { |n| "sku_#{n}" }

    factory :one_month_product do
      title { "1 Month Only" }
      amount { 100 }
      sku { "MEMBERSHIP_ONE_MONTH" }
    end

    factory :monthly_subscription_product do
      title { "Subscribe Monthly" }
      amount { 80 }
      sku { "MEMBERSHIP_MONTHLY_SUBSCRIPTION" }
    end
  end
end
