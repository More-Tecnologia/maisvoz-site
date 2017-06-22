module Shopping
  class UpdateCartTotals

    def self.call(order)
      ActiveRecord::Base.transaction do
        update_order_items(order)
        update_order(order)
      end
    end

    def self.update_order_items(order)
      order.order_items.each do |oi|
        product = oi.product
        oi.unit_price_cents = product.price_cents
        oi.total_cents = oi.quantity * product.price_cents
        oi.save!
      end
    end

    def self.update_order(order)
      order.subtotal_cents = order.order_items.collect(&:total_cents).sum
      order.total_cents = order.tax_cents + order.shipping_cents + order.subtotal_cents
      order.save!
    end

  end
end
