FactoryBot.define do
  factory :product_reason_score do
    product { association(:product) }
    financial_reason { association(:financial_reason) }
  end
end
