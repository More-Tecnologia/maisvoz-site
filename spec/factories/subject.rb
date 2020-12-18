FactoryBot.define do
  factory :subject do
    name { Faker::Name.name }
    active { true }
  end
end
