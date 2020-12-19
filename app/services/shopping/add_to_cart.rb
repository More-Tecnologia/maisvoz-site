module Shopping
  class AddToCart

    prepend SimpleCommand

    def initialize(order, product_id, country)
      @order = order
      @product_id = product_id
      @country = country
    end

    def call
      ActiveRecord::Base.transaction do
        if !product.active?
          errors.add(:product, I18n.t('product_is_not_active'))
        elsif find_order_item.present? && product.adhesion?
          errors.add(:product, I18n.t('cant_add_produt_to_cart'))
        elsif product.adhesion? && already_another_adhesion_product?
          errors.add(:product, I18n.t('there_are_adhesion_product'))
        elsif add_to_order
          update_order_total
          update_order_pv_total
          return order
        else
          errors.add(:product, I18n.t('cant_add_produt_to_cart'))
        end
      end
    end

    private

    attr_reader :order, :product_id, :country

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

    def add_membership_item_to_order
      @order.order_items.create(product: membership_product,
                                quantity: 1,
                                unit_price_cents: membership_product.price_cents,
                                total_cents: membership_product.price_cents * 1)
    end

    def update_order_total
      Shopping::UpdateCartTotals.call(order, country)
    end

    def apply_discount
      discount = item_subscription.total_cents
      order.decrement!(:total_cents, discount)
    end

    def update_order_pv_total
      order.update!(pv_total: order.total_score)
    end

    def find_order_item
      @order_item ||= order.order_items.find_by(product: product)
    end

    def product
      @product ||= Product.find(product_id)
    end

    def already_another_adhesion_product?
      order.try(:order_items).any? { |i| i.try(:product).try(:adhesion?) }
    end

    def membership_product
      @membership_product = Product.find(1)
    end

    def user_first_buy?
      !order.user.orders.completed.any?
    end

    def detect_membership_added?
      @order.products.detect { |q| q == membership_product }
    end

    def item_subscription
      @item_subscription ||= OrderItem.where(order: order.user.orders.completed.paid,
                                             product: Product.subscription).first
    end

  end
end
