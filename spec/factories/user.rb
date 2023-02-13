FactoryBot.define do
  factory :user do
    trait :with_required_attributes_as_user do
      sequence(:name) { |i| "user#{i}" }
      sequence(:email) { |i| "user#{i}@example.com" }
      sequence(:password) { |i| "SecureUserPassword#{i}!" }
      role { :user }
    end

    trait :with_required_attributes_as_confirmed_user do
      sequence(:name) { |i| "confirmed_user#{i}" }
      sequence(:email) { |i| "confirmed_user#{i}@example.com" }
      sequence(:password) { |i| "SecureUserPassword#{i}!" }
      role { :user }
      confirmed_at { DateTime.now }
    end

    trait :with_required_attributes_as_super do
      sequence(:name) { |i| "super#{i}" }
      sequence(:email) { |i| "super#{i}@example.com" }
      sequence(:password) { |i| "SecureSuperPassword#{i}!" }
      role { :super }
    end

    trait :with_required_attributes_as_admin do
      sequence(:name) { |i| "admin#{i}" }
      sequence(:email) { |i| "admin#{i}@example.com" }
      sequence(:password) { |i| "SecureAdminPassword#{i}!" }
      role { :admin }
    end

    trait :with_required_attributes_as_trackable_system_admin do
      sequence(:name) { |i| "trackable_system_admin#{i}" }
      sequence(:email) { |i| "trackable_system_admin#{i}@example.com" }
      sequence(:password) { |i| "SecureTrackableSystemAdminPassword#{i}!" }
      role { :trackable_system_admin }
    end
  end
end
