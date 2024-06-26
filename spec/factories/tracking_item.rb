FactoryBot.define do
  factory :tracking_item_request, class: OpenStruct do
    trait :create do
      to { build(:tracking, :with_realistic_attributes).to }
      status { build(:tracking, :with_realistic_attributes).status }
      metadata { build(:tracking, :with_realistic_attributes).metadata }
      user_id { create(:user).id }
      from { build(:tracking, :with_realistic_attributes).from }
    end

    trait :create_invalid do
    end
  end

  factory :tracking_item do
    trait :with_required_dependencies do
      user { create(:user, :with_required_attributes_as_user) }
    end

    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
    end
  end
end
