FactoryBot.define do
  factory :binary_node do
    user { create(:user) }
    sponsored_by { user.sponsor }
    parent { nil }
    left_child { nil }
    right_child { nil }
  end
end
