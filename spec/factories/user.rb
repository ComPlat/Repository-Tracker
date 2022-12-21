FactoryBot.define do
  factory :user do
    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
      sequence(:email) { |i| "email#{i}@example.com" }
      sequence(:password) { |i| "password#{i}" }
      role { :user }
    end

    trait :with_access_toe do
      sequence(:name) { |i| "name#{i}" }
      sequence(:email) { |i| "email#{i}@example.com" }
      sequence(:password) { |i| "password#{i}" }
      role { :user }
    end
  end
end
