FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    quantity { rand(1..5) }
    category { association(:category) }
    binary_score { Faker::Number.positive.to_i }
    active { true }
    binary_bonus { rand(1..100) }
    kind { Product.kinds.keys.sample }
    price_cents { Faker::Number.positive.to_i }
    maturity_days { [10, 20] }
    grace_period { (1..10).to_a.sample }
    code { Faker::Number.positive }

    trait :adhesion do
      kind { :adhesion }
    end

    trait :detached do
      kind { :detached }
    end

    trait :activation do
      kind { :activation }
    end

    trait :voucher do
      kind { :voucher }
    end

    trait :deposit do
      kind { :deposit }
    end

    trait :subscription do
      kind { :subscription }
    end
  end
end