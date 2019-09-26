module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user  = order.user
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
      order.with_lock do
        update_order_status
        update_user_flags
        update_user_role
        update_subscription
        activate_tracker
        activate_user
        assign_product_to_user
        create_binary_node
        qualify_sponsor
        propagate_binary_score
        propagate_pv_history
        credit_bonus
        create_system_fee
        order.completed!
      end
      binary_bonus_nodes_verifier
      ShoppingMailer.with(order: order).order_paid.deliver_later
      DROrderTransmitterWorker.perform_async(order.id)
      true
    end

    def update_order_status
      if regular_product?
        order.processing!
      else
        order.completed!
      end

      order.paid_at = Time.zone.now
      order.save!
    end

    def create_binary_node
      return unless user.binary_node.blank? && adhesion_product?

      Multilevel::CreateBinaryNode.new(user).call
    end

    def qualify_sponsor
      return if user.sponsor.blank? || user.sponsor.binary_qualified?

      Multilevel::QualifyUser.new(user.sponsor).call
    end

    def propagate_binary_score
      Bonification::PropagateBinaryScore.new(order).call
    end

    def propagate_pv_history
      Bonification::PropagatePvgHistory.new(order).call
      Bonification::PropagatePvaPoints.new(order: order).call
    end

    def credit_bonus
      Bonification::CreditExecutiveSaleBonus.new(order).call
      Bonification::CreditIndirectBonus.new(order).call
      Bonification::CreditDirectIndicationBonus.new(order).call
    end

    def create_system_fee
      Fee::CreateSystemFee.new(order).call
    end

    def update_user_flags
      user.update!(bought_adhesion: true) if adhesion_product?
      user.update!(bought_product: true) if regular_product?
    end

    def update_user_role
      return unless user.consumidor? && adhesion_product?

      user.empreendedor!
      user.affiliate!
      user.unilevel_node.affiliate!

      CareerHistory.new.tap do |log|
        log.user       = user
        log.new_career = User::AFFILIATE
        log.save!
      end
    end

    def update_subscription
      Subscriptions::Compensate.new(order: order).call
    end

    def activate_user
      return if user.active? || !adhesion_product?

      user.update!(active: true, active_until: 30.days.from_now)
    end

    def assign_product_to_user
      return if order.club_motors_product.blank?

      user.update!(product: order.club_motors_product)
    end

    def binary_bonus_nodes_verifier
      return if order.user.binary_node.blank?

      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    end

    def adhesion_product?
      adhesion_product.present?
    end

    def adhesion_product
      order.adhesion_product
    end

    def regular_product?
      @regular_product ||= order.order_items.joins(:product).where(
        'products.kind = ?', Product.kinds[:product]
      ).any?
    end

  end
end
