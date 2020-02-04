FactoryBot.define do
  factory :payment_transaction do
    order { association(:order, :with_order_itens) }
    status { PaymentTransaction.statuses.keys.first }
    transaction_id { Faker::Number.positive.to_i }
    amount { Faker::Number.positive.to_i }
  end
end
