FactoryBot.define do
  factory :product do
    factory :one_month do
      title { "1 Month Only" }
      description { "description test" }
      amount { 100 }
      sku { "MEMBERSHIP_ONE_MONTH" }
    end

    factory :subscribe_monthly do
      title { "Subscribe Monthly" }
      description { "description test" }
      amount { 80 }
      sku { "MEMBERSHIP_MONTHLY_SUBSCRIPTION" }
    end
  end
end
