FactoryBot.define do
  factory :user do
    trait :with_required_attributes do
      sequence(:name) { |i| "user#{i}" }
      sequence(:email) { |i| "user#{i}@example.com" }
      sequence(:password) { |i| "password#{i}" }
      role { :user }
    end

    trait :with_required_attributes_as_admin do
      sequence(:name) { |i| "admin#{i}" }
      sequence(:email) { |i| "admin#{i}@example.com" }
      sequence(:password) { |i| "password#{i}" }
      role { :admin }
    end
  end
end
