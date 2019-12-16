FactoryBot.define do
  factory :sim_card do
    iccid { Faker::Code.ean }
    phone_number { Faker::Number.number(digits: 13) }
    status { SimCard.statuses.keys.sample }
    status_change_date { Faker::Time.backward(days: 14) }
    user { association(:user) }
    order_item { association(:order_item) }
    support_point_user { association(:user) }
  end
end
