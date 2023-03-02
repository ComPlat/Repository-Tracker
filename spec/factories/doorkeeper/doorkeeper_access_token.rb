FactoryBot.define do
  factory :doorkeeper_access_token, class: "Doorkeeper::AccessToken" do
    trait :with_required_dependencies do
      resource_owner_id { create(:user, :with_required_attributes_as_user).id }
      application { Doorkeeper::Application.find_by!(name: "React SPA API Client") }
    end
  end
end
