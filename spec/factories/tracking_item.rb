FactoryBot.define do
  factory :tracking_item_request, class: OpenStruct do
    to { build(:tracking, :with_realistic_attributes).to }
    status { build(:tracking, :with_realistic_attributes).status }
    metadata { build(:tracking, :with_realistic_attributes).metadata }
    user_id { create(:user).id }

    trait :create do
      from { build(:tracking, :with_realistic_attributes).from }
    end

    trait :create_invalid do
    end
  end

  factory :tracking_item do
    trait :with_required_dependencies do
      user { create :user, :with_required_attributes }
    end

    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
    end
  end
end
