FactoryBot.define do
  factory :tracking_request, class: OpenStruct do
    trait :create do
      status { build(:tracking, :with_required_attributes).status }
      metadata { build(:tracking, :with_required_attributes).metadata }
      tracking_item_name { create(:tracking_item, :with_required_attributes, :with_required_dependencies).name }
      from_trackable_system_name { find_or_create(:trackable_system, :with_required_attributes).name }
      to_trackable_system_name { find_or_create(:trackable_system, :with_required_attributes).name }
    end

    trait :create_invalid do
    end
  end

  factory :tracking do
    trait :with_required_dependencies do
      tracking_item { create :tracking_item, :with_required_attributes, :with_required_dependencies }
      from_trackable_system { find_or_create :trackable_system, :with_required_attributes }
      to_trackable_system { find_or_create :trackable_system, :with_required_attributes }
    end

    trait :with_required_attributes do
      status { :draft }
      metadata { {key: "value"} }
    end
  end
end
