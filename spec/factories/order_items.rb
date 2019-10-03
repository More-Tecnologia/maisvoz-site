FactoryBot.define do
  factory :order_item do
    quantity { rand(1..5) }
    order { association(:order) }
    product { association(:product) }

    trait :detached do
      product { association(:product, :detached) }
    end

    trait :adhesion do
      product { association(:product, :adhesion) }
    end

    trait :activation do
      product { association(:product, :activation) }
    end
  end
end
