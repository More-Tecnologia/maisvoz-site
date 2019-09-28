FactoryBot.define do
  factory :career_trail do
    career { association(:career) }
    trail { association(:trail) }
  end
end
