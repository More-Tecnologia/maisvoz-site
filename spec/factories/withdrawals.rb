FactoryBot.define do
  factory :withdrawal do
    user { association(:user) }
    status { Withdrawal.statuses.keys.sample }
    gross_amount_cents { Faker::Number.positive.to_i }
    net_amount_cents { Faker::Number.positive.to_i }
  end
end
