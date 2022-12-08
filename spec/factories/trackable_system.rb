FactoryBot.define do
  factory :trackable_system do
    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
    end
  end
end
