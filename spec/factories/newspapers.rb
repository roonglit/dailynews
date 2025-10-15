FactoryBot.define do
  factory :newspaper do
    title { "Example Book" }
    published_at { Date.today }
    created_at { Date.today }
  end
end
