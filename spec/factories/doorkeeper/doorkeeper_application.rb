FactoryBot.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do
    trait :with_required_attributes do
      name { "React SPA API Client" }
    end

    trait :with_required_dependencies do
      resource_owner_id { create(:user, :with_required_attributes).id }
    end
  end
end
