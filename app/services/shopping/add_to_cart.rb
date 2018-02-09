module Shopping
  class AddToCart

    prepend SimpleCommand

    def initialize(order, product_id)
      @order = order
      @product_id = product_id
    end

    def call
      ActiveRecord::Base.transaction do
        if !product.active?
          errors.add(:product, 'product is not active')
        elsif find_order_item.present? && product.adhesion?
          errors.add(:product, 'cant add product to cart')
        elsif add_to_order
          update_order_total
          update_order_pv_total
          return order
        else
          errors.add(:product, 'cant add product to cart')
        end
      end
    end

    private

    attr_reader :order, :product_id

    def add_to_order
      if find_order_item.present?
        update_order_item
      else
        create_order_item
      end
    end

    def create_order_item
      order_item = OrderItem.new
      order_item.product = product
      order_item.quantity = 1
      order_item.unit_price_cents = product.price_cents
      order_item.total_cents = product.price_cents
      order.order_items << order_item
      order.save!
      order_item
    end

    def update_order_item
      order_item = find_order_item
      order_item.quantity += 1
      order_item.unit_price_cents = product.price_cents
      order_item.total_cents = product.price_cents * order_item.quantity
      order_item.save!
    end

    def update_order_total
      Shopping::UpdateCartTotals.call(order)
    end

    def update_order_pv_total
      order.update(pv_total: order.total_score)
    end

    def find_order_item
      @order_item ||= order.order_items.find_by(product: product)
    end

    def product
      @product ||= Product.find(product_id)
    end

  end
end
