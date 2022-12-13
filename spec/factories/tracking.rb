FactoryBot.define do
  factory :tracking_request, class: OpenStruct do
    to { build(:tracking, :with_realistic_attributes).to }
    status { build(:tracking, :with_realistic_attributes).status }
    metadata { build(:tracking, :with_realistic_attributes).metadata }
    user_id { create(:user).id }

    trait :create do
      from { build(:tracking, :with_realistic_attributes).from }
    end

    trait :create_invalid do
    end

    trait :update do
      id { "1" }
      status { %w[draft published submitted].sample }
    end
  end

  factory :tracking do
    trait :with_required_dependencies do
      status { :draft }
      tracking_item { create :tracking_item, :with_required_attributes, :with_required_dependencies }
      from_trackable_system { find_or_create :trackable_system, :with_required_attributes }
      to_trackable_system { find_or_create :trackable_system, :with_required_attributes }
    end

    trait :with_required_attributes do
      metadata { {key: "value"} }
    end
  end
end
