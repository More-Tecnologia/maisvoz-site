FactoryBot.define do
  factory :product_score do
    receiving_maximum_generation { Faker::Number.positive.to_i }
    cent_amount { Faker::Number.positive.to_i }
  end
end
