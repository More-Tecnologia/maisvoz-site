FactoryBot.define do
  factory :role_type do
    name { Faker::Lorem.sentence }
    code { Faker::Number.positive.to_i }
  end
end
