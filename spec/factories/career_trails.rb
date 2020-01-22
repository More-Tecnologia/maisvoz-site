FactoryBot.define do
  factory :career_trail do
    career { association(:career) }
    trail { association(:trail) }
    product { association(:product, :activation) }
  end
end
