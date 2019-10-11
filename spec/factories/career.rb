FactoryBot.define do
  factory :career do
    name { Faker::Name.name }
    qualifying_score { Faker::Number.positive }
    requalification_score { Faker::Number.positive.to_i }
  end
end
