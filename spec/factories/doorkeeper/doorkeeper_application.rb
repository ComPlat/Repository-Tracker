FactoryBot.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do
    trait :with_required_attributes do
      name { "React SPA API Client" }
      uid { ENV["DOORKEEPER_CLIENT_ID"] }
    end
  end
end
