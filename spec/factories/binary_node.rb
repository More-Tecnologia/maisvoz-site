FactoryBot.define do
  factory :binary_node do
    user { create(:user) }
    parent { nil }
    left_child { nil }
    right_child { nil }
  end
end
