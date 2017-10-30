module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user = order.user
    end

    def call
      if order.open?
        errors.add(:order, 'no carrinho ainda')
      elsif !order.pending_payment?
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
        update_user_flags
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
      Bonification::PropagateBinaryScore.new(order).call
    end

    def create_pv_activity_history
      Bonification::CreatePvActivityHistory.new(order).call
    end

    def update_user_flags
      user.update(bought_adhesion: true) if !user.bought_adhesion && adhesion_product.present?
      user.update(bought_product: true) if !user.bought_product && regular_product.present?
    end

    def binary_bonus_nodes_verifier
      return if order.user.binary_node.blank?
      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    end

    def adhesion_product
      @adhesion_product ||= order.order_items.map(&:product).find(&:adhesion?)
    end

    def regular_product
      @regular_product ||= order.order_items.map(&:product).find(&:product?)
    end

    def any_product?
      order.order_items.any? do |oi|
        oi.product.product?
      end
    end

  end
end
