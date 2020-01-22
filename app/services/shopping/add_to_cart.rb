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
          errors.add(:product, I18n.t('product_is_not_active'))
        elsif find_order_item.present? && product.adhesion?
          errors.add(:product, I18n.t('cant_add_produt_to_cart'))
        elsif product.adhesion? && already_another_adhesion_product?
          errors.add(:product, I18n.t('there_are_adhesion_product'))
        elsif add_to_order
          update_order_total
          update_order_pv_total
          apply_discount if can_apply_discount_to_subscription_users?
          return order
        else
          errors.add(:product, I18n.t('cant_add_produt_to_cart'))
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

    def user_bought_subscription?
      item_subscription
    end

    def item_subscription
      @item_subscription ||= OrderItem.where(order: order.user.orders.completed.paid,
                                             product: Product.subscription).first
    end

    def exists_adhesion_order_pending_payment?
      OrderItem.exists?(order: order.user.orders.pending_payment,
                        product: Product.adhesion)
    end

    def can_apply_discount_to_subscription_users?
      user_bought_subscription? && product.adhesion? && !order.user.bought_adhesion && !exists_adhesion_order_pending_payment?
    end

  end
end
