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
        create_pv_activity_history
      end
      binary_bonus_nodes_verifier
    end

    def update_order_status
      if any_product?
        order.status = Order.statuses[:processing]
      else
        order.status = Order.statuses[:completed]
      end

      order.paid_at = Time.zone.now
      order.save!
    end

    def create_binary_node
      return unless adhesion_product.present?
      Multilevel::CreateBinaryNode.new(user, adhesion_product.career).call
    end

    def propagate_binary_score
      Bonus::PropagateBinaryScore.new(order).call
    end

    def create_pv_activity_history
      Bonus::CreatePvActivityHistory.new(order).call
    end

    def binary_bonus_nodes_verifier
      return if order.user.binary_node.blank?
      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
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
