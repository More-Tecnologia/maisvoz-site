FactoryBot.define do
  factory :rule_type do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    ruleable_name { Faker::Name.first_name }
  end
end
