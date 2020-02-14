FactoryBot.define do
  factory :pool_tranding do
    amount { Faker::Number.decimal(l_digits: 2) }
  end
end
