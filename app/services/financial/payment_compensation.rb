module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order)
      @order = order
      @user  = order.user
    end

    def call
      return errors.add(:order, :still_in_cart) if order.cart?
      return errors.add(:order, :already_approved) if !order.pending_payment?
      return order if compensate_order
      errors.add(:order, :invalid)
    end

    private

    attr_reader :order, :user

    def compensate_order
      ActiveRecord::Base.transaction do
        order.paid!
        upgrade_user_career if first_adhesion?
        upgrade_user_trail if upgraded_trail?
        update_user_purchase_flags
        activate_user if adhesion_product
        update_user_role if subscription_product
        insert_into_binary_tree if user.out_binary_tree? && adhesion_product
        qualify_sponsor if user.sponsor_is_binary_qualified?
        propagate_binary_score
        propagate_products_scores
        propagate_bonuses
        create_vouchers
        create_system_fee
        binary_bonus_nodes_verifier if user.inside_binary_tree?
        notify_user_by_email_about_paid_order
      end
      binary_bonus_nodes_verifier if user.inside_binary_tree?
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
      Bonification::Propagator::BinaryScoreService.call(order: order)
    end

    def propagate_products_scores
      Bonification::AdhesionProductScorePropagator.call(order: order) if adhesion_product
      Bonification::DetachedProductScorePropagator.call(order: order)
      Bonification::ActivationProductScorePropagator.call(order: order)
    end

    def propagate_bonuses
      Bonification::BonusPropagatorService.call(order: order)
    end

    def create_vouchers
      return unless voucher_product
      Vouchers::Create.new(user: user, product: voucher_product).call
    end

    def create_system_fee
      Financial::CreatorSystemFeeService.call(order: order)
    end

    def update_user_purchase_flags
      attributes = {}
      attributes.merge!(bought_adhesion: true) if adhesion_product
      attributes.merge!(bought_product: true) if regular_product?
      user.update_attributes!(attributes)
    end

    def upgrade_user_career
      UpgraderCareerService.call(user: user)
    end

    def upgrade_user_trail
      trail = adhesion_product.try(:trail)
      UpgraderTrailService.call(user: user, trail: trail) if trail
    end

    def activate_user
      user.activate!
    end

    def update_user_role
      user.update_attributes!(role: 'empreendedor')
    end

    def binary_bonus_nodes_verifier
      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    end

    def adhesion_product
      @adhesion_product ||= order.products.detect(&:adhesion?)
    end

    def regular_product?
      @regular_product ||= order.products.detect(&:regular?)
    end

    def voucher_product
      @voucher_product ||= order.products.detect(&:voucher?)
    end

    def subscription_product
      @subscription_product ||= order.products.detect(&:subscription?)
    end

    def new_trail?
      user.current_trail != adhesion_product.try(:trail)
    end

    def upgraded_trail?
      user.bought_adhesion && new_trail?
    end

    def first_adhesion?
      !user.bought_adhesion && adhesion_product
    end

    def inside_binary_tree?
      user.binary_node
    end

    def notify_user_by_email_about_paid_order
      ShoppingMailer.with(order: order).order_paid.deliver_later
    end
  end
end
