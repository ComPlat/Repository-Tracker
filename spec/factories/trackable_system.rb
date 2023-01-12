FactoryBot.define do
  factory :trackable_system do
    trait :with_required_attributes do
      name { %w[radar4kit radar4chem chemotion_repository chemotion_electronic_laboratory_notebook nmrxiv].sample }
    end

    trait :with_required_dependencies do
      user { create(:user, :with_required_attributes) }
    end
  end
end
