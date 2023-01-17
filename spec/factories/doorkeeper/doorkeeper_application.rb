FactoryBot.define do
  factory :doorkeeper_application, class: "Doorkeeper::Application" do
    trait :with_required_attributes do
      sequence(:name) { |i| "name#{i}" }
    end
  end
end
