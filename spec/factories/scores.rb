FactoryBot.define do
  factory :score do
    order { association(:order) }
    user { association(:user) }
    spreader_user { association(:user) }
    score_type { association(:score_type) }
    cent_amount { Faker::Number.positive.to_i }
    height { rand(0..10) }
    source_leg { Score.source_legs.keys.first }
  end
end
