FactoryBot.define do
  factory :financial_reason do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
