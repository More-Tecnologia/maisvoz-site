module Shopping
  class UpdateCartTotals
    def self.call(order, country = nil)
      ActiveRecord::Base.transaction do
        update_order_items(order, country)
        update_order(order)
        order
      end
    end

    def self.update_order_items(order, country)
      order.order_items.each do |oi|
        product = oi.product
        shipping = product.shippings.index_by(&:country)[country]

        oi.unit_price_cents = product.price_cents
        oi.shipping_cents = shipping.try(:amount).to_f * oi.quantity
        oi.total_cents = oi.quantity * product.price_cents
        oi.save!
      end
    end

    def self.update_order(order)
      order.subtotal_cents = order.order_items.sum(&:total_cents)
      order.shipping_cents = order.order_items.sum { |oi| oi.shipping_cents.to_f }
      order.total_cents = order.tax_cents + order.shipping_cents + order.subtotal_cents
      order.save!
    end
  end
end
