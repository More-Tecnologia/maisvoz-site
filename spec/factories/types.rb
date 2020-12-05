FactoryBot.define do
  factory :type do
    name { Faker::Name.name }
    indications_quantity { Faker::Number.digit.to_i }
    bonus_percentage { Faker::Number.decimal }
    qualify_by_user_activity { Faker::Boolean.boolean(true_ratio: 0.5) }
  end
end
