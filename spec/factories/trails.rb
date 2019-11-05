FactoryBot.define do
  factory :trail do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    product { association(:product) }
  end
end
