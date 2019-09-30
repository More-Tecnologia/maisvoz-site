FactoryBot.define do
  factory :financial_transaction do
    user { association(:user) }
    financial_reason { association(:financial_reason) }
    operator { association(:user) }
    cent_amount { Faker::Number.positive.to_i }
  end
end
