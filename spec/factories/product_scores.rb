FactoryBot.define do
  factory :product_score do
    generation { rand(0..10) }
    cent_amount { Faker::Number.positive.to_i }
    career_trail { association(:career_trail) }
  end
end
