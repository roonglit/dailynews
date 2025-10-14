FactoryBot.define do
  factory :newspaper do
    title { "Example Book" }
    created_at { Date.today }
  end
end
