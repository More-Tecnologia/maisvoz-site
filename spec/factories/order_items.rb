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

    trait :voucher do
      product { association(:product, :voucher) }
    end

    trait :subscription do
      product { association(:product, :subscription) }
    end

    trait :deposit do
      product { association(:product, :deposit) }
    end

    trait :recharge do
      product { association(:product, :recharge) }
    end
  end
end
