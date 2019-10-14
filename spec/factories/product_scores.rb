FactoryBot.define do
  factory :product_score do
    generation { rand(0..10) }
    amount_cents { Faker::Number.positive.to_i }
    career_trail { association(:career_trail) }
    product_reason_score { association(:product_reason_score) }
  end
end
