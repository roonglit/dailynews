FactoryBot.define do
  factory :order do
    association :member
    state { :pending }
    total_cents { 10000 }
    sub_total_cents { 10000 }
  end
end
