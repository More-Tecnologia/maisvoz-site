module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user = order.user
    end

    def call
      if !order.pending_payment?
        errors.add(:order, 'já foi aprovado')
      elsif compensate_order
        return order
      else
        errors.add(:order, 'error')
      end
      nil
    end

    private

    attr_reader :order, :user

    def compensate_order
      ActiveRecord::Base.transaction do
        update_order_status
        create_binary_node
        propagate_binary_score
      end
    end

    def update_order_status
      if any_product?
        order.processing!
      else
        order.completed!
      end
    end

    def create_binary_node
      return unless adhesion_product.present?
      Multilevel::CreateBinaryNode.new(user, adhesion_product.career).call
    end

    def propagate_binary_score
      Bonus::PropagateBinaryScore.call(order)
    end

    def adhesion_product
      @adhesion_product ||= order.order_items.map(&:product).find(&:adhesion?)
    end

    def any_product?
      order.order_items.any? do |oi|
        oi.product.product?
      end
    end

  end
end
