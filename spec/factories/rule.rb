FactoryBot.define do
  factory :rule do
    rule_type { association(:rule_type) }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
