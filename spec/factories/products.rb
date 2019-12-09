FactoryBot.define do
  factory :product do
    quantity { rand(1..5) }
    binary_score { Faker::Number.positive }
    active { true }
    binary_bonus { rand(1..100) }
    kind { Product.kinds.keys.sample }
    price_cents { Faker::Number.positive.to_i }
    maturity_days { [10, 20] }
    grace_period { (1..10).to_a.sample }

    trait :adhesion do
      kind { :adhesion }
    end

    trait :detached do
      kind { :detached }
    end

    trait :activation do
      kind { :activation }
    end
  end
end
