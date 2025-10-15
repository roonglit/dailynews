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
  end
end
