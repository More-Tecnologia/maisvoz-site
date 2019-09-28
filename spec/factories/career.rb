FactoryBot.define do
  factory :career do
    name { Faker::Name.name }
    qualifying_score { Faker::Number.positive }
  end
end
