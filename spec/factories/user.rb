FactoryBot.define do
  factory :user do
    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
      role { :user }
    end
  end
end
