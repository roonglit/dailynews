FactoryBot.define do
  factory :newspaper do
    title { "Example Book" }
    description {  "Description example" }
    published_at { Date.today }
  end
end
