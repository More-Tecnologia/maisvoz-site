module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user = order.user
    end

    def call
      if order.cart?
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
        update_user_flags
        create_binary_node
        activate_binary_node
        qualify_sponsor
        propagate_binary_score
        create_pv_activity_history
      end
      binary_bonus_nodes_verifier
    end

    def update_order_status
      if regular_product?
        order.status = Order.statuses[:processing]
      else
        order.status = Order.statuses[:completed]
      end

      order.paid_at = Time.zone.now
      order.save!
    end

    def create_binary_node
      return unless adhesion_product.present?
      Multilevel::CreateBinaryNode.new(
        user,
        adhesion_product.career
      ).call
    end

    def activate_binary_node
      return if user.binary_node.blank? || user.binary_node.active || !regular_product?
      user.binary_node.update!(
        active: true,
        active_until: 6.months.from_now
      )
    end

    def qualify_sponsor
      return if user.sponsor.blank? || user.sponsor.qualified?
      Multilevel::QualifyUser.new(user.sponsor).call
    end

    def propagate_binary_score
      Bonification::PropagateBinaryScore.new(order).call
    end

    def create_pv_activity_history
      Bonification::CreatePvActivityHistory.new(order).call
    end

    def update_user_flags
      user.update!(bought_adhesion: true) if !user.bought_adhesion && adhesion_product.present?
      user.update!(bought_product: true) if !user.bought_product && regular_product?
    end

    def binary_bonus_nodes_verifier
      return if order.user.binary_node.blank?
      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    end

    def adhesion_product
      @adhesion_product ||= order.order_items.joins(:product).where(
        'products.kind = ?', Product.kinds[:adhesion]
      ).first.try(:product)
    end

    def regular_product?
      @regular_product ||= order.order_items.joins(:product).where(
        'products.kind = ?', Product.kinds[:product]
      ).any?
    end

  end
end
