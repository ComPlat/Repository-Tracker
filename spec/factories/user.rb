FactoryBot.define do
  factory :user do
    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
      sequence(:email) { |i| "email#{i}@example.com" }
      sequence(:password) { |i| "SecurePassword#{i}-" }
      role { :user }
    end
  end
end
