FactoryBot.define do
  factory :score_type do
    name { Faker::Name.unique.first_name }
    tree_type { :unilevel }

    trait :binary_tree_type do
      tree_type { :binary }
    end
  end
end
