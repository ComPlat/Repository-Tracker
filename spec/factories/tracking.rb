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
      status { ["draft", "published", "submitted"].sample }
    end
  end

  factory :tracking do
    trait :with_required_dependencies do
      user { create :user }
    end

    trait :with_realistic_attributes do
      from { ["ELN", "RARDA4KIT", "REPO"].sample }
      to { ["RARDA4Kit", "RARDA4Chem", "REPO", "nmrXiv"].sample }
      status { ["draft", "published", "submitted"].sample }
      metadata {
        {"item1" => "value1",
         "item2" => "value2",
         "item3" => "value3"}
      }
    end
  end
end
