FactoryBot.define do
  factory :financial_reason_type do
    name { Faker::Name.first_name }
    code { Faker::Number.positive.to_i.to_s }
  end
end
