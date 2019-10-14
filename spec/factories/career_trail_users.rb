FactoryBot.define do
  factory :career_trail_user do
    career_trail { association(:career_trail) }
    user { association(:user) }
  end
end
