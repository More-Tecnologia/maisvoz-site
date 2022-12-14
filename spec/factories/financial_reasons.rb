FactoryBot.define do
  factory :financial_reason do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    financial_reason_type { association(:financial_reason_type) }
    code { Faker::Number.positive.to_i.to_s }
  end
end
