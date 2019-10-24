FactoryBot.define do
  factory :financial_transaction do
    user { association(:user) }
    financial_reason { association(:financial_reason) }
    spreader { association(:user) }
    cent_amount { Faker::Number.positive.to_i }
    order { association(:order) }
    generation { ([''] + (1..10).to_a).sample }
    moneyflow { FinancialTransaction.moneyflows.keys.sample }

    trait :with_note do
      note { Faker::Lorem.paragraph }
    end
  end
end
