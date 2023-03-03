FactoryBot.define do
  factory :doorkeeper_access_token, class: "Doorkeeper::AccessToken" do
    trait :with_required_dependencies do
      resource_owner_id { create(:user, :with_required_attributes_as_user).id }
      application {
        create(:doorkeeper_application,
          :with_required_attributes,
          uid: ENV["DOORKEEPER_CLIENT_ID"])
      }
    end
  end
end
