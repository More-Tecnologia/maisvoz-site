FactoryBot.define do
  factory :order do
    user { association(:user) }
    subtotal_cents { Faker::Number.positive.to_i }
    tax { (subtotal_cents * 0.1).to_i }
    shipping_cents { tax }
    total_cents { (subtotal_cents * 0.9).to_i }
    status { Order.statuses.keys.sample }
    created_at { Date.today }
    updated_at { Date.today }
    paid_at { created_at + 1.day }
    pv_total { Faker::Number.positive.to_i }
    payment_type { Order.payment_types[:boleto] }
    paid_by { '' }
    billed { true }

    trait :with_order_itens do
      order_items { Product.kinds.keys.map { |kind| create(:order_item, kind) } }
    end
  end
end
