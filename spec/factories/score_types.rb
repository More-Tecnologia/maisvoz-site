FactoryBot.define do
  factory :score_type do
    name { Faker::Name.unique.first_name }
  end
end
