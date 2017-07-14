module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user = order.user
    end

    def call
      if compensate_order
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
      return unless adhesion_product?
      Multilevel::CreateBinaryNode.new(user).call
    end

    def adhesion_product?
      order.order_items.any? do |oi|
        oi.product.adhesion?
      end
    end

    def any_product?
      order.order_items.any? do |oi|
        oi.product.product?
      end
    end

  end
end
