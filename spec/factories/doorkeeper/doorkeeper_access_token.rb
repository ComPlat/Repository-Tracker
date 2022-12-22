FactoryBot.define do
  factory :doorkeeper_access_token, class: "Doorkeeper::AccessToken" do
    trait :with_required_dependencies do
      resource_owner_id { create(:user, :with_required_attributes).id }
      application { create(:doorkeeper_application, :with_required_attributes) }
    end
  end
end
