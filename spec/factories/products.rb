FactoryBot.define do
  factory :product do
    quantity { rand(1..5) }
    binary_score { Faker::Number.positive }
    active { true }
    binary_bonus { Faker::Number.decimal }
    kind { Product.kinds.keys.sample }
    price_cents { Faker::Number.positive.to_i }

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
