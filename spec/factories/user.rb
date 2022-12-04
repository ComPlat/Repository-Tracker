FactoryBot.define do
  factory :user do
    trait :with_realistic_attributes do
      sequence(:name) { |i| "name#{i}" }
    end
  end
end
