FactoryBot.define do
  factory :rule_ruleable do
    trait :ruleable_missmatch_rule_type do
      rule { association(:rule) }
      ruleable { association(:score_type) }
    end
  end
end
