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
        upgrade_user_career if first_adhesion?
        upgrade_user_trail if upgraded_trail?
        update_user_purchase_flags
        activate_user
        insert_into_binary_tree if user.out_binary_tree? && adhesion_product?
        qualify_sponsor if user.sponsor_is_binary_qualified?
        #propagate_binary_score
        propagate_pv_history
        credit_bonus
        create_system_fee
        order.completed!
      end
      # binary_bonus_nodes_verifier if user.inside_binary_tree?
      notify_user_by_email_about_paid_order
    end

    def update_order_status
      attributes = {}
      attributes.merge!(status: :completed, paid_at: Time.zone.new)
      attributes.merge!(status: :processing) if regular_product?
      order.update_attributes!(attributes)
    end

    def insert_into_binary_tree
      Multilevel::CreateBinaryNode.new(user).call
    end

    def qualify_sponsor
      Multilevel::QualifyUser.new(user.sponsor).call if user.sponsor.try(:binary_qualified?)
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

    def update_user_purchase_flags
      attributes = {}
      attributes.merge!(bought_adhesion: true) if adhesion_product
      attributes.merge!(bought_product: true) if regular_product?
      user.update_attributes!(attributes)
    end

    def upgrade_user_career
      UpgrderCareerService.call(user: user)
    end

    def upgrade_user_trail
      trail = adhesion_product.try(:trail)
      UpgraderTrailService.call(user: user, trail: trail) if trail
    end

    def activate_user
      return if user.active? || !adhesion_product?
      user.activate!
    end

    # def binary_bonus_nodes_verifier
    #   NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    # end

    def adhesion_product
      @adhesion_product ||= order.products.detect(&:adhesion?)
    end

    def regular_product?
      @regular_product ||= order.products.detect(&:regular?)
    end

    def new_trail?
      user.current_trail != adhesion_product.try(:trail)
    end

    def upgraded_trail?
      user.bought_adhesion && new_trail?
    end

    def first_adhesion?
      !user.bought_adhesion && adhesion_product?
    end

    def inside_binary_tree?
      user.binary_node
    end

    def notify_user_by_email_about_paid_order
      ShoppingMailer.with(order: order).order_paid.deliver_later
    end
  end
end
