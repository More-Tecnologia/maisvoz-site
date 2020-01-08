module Financial
  class PaymentCompensation

    prepend SimpleCommand

    def initialize(order, enabled_bonification = true)
      @order = order
      @user  = order.user
      @enabled_bonification = enabled_bonification
    end

    def call
      return errors.add(:order, :still_in_cart) if order.cart?
      return errors.add(:order, :already_approved) if !order.pending_payment?
      return order if compensate_order
      errors.add(:order, :invalid)
    end

    private

    attr_reader :order, :user, :enabled_bonification

    def compensate_order
      ActiveRecord::Base.transaction do
        create_order_payment
        update_user_purchase_flags
        upgrade_user_trail if upgraded_trail?
        update_user_purchase_flags
        activate_user if adhesion_product
        activate_user_until! if activation_product && validates_code_of?(activation_product) && enabled_activation?
        user.empreendedor! if adhesion_product
        update_user_role if subscription_product
        insert_into_binary_tree if user.out_binary_tree? && adhesion_product
        qualify_sponsor if !user.sponsor_is_binary_qualified? && user.active && enabled_binary?
        propagate_binary_score if enabled_bonification && enabled_binary?
        propagate_products_scores if enabled_bonification
        upgrade_career_from(user.sponsor)
        upgrade_career_from(user) if adhesion_product
        propagate_bonuses if enabled_bonification
        create_vouchers
        create_system_fee
        associate_support_point if adhesion_product
        binary_bonus_nodes_verifier if user.inside_binary_tree? && enabled_bonification && enabled_binary?
        add_product_bonus_to_order if adhesion_product
        create_support_point_activation_bonus if activation_product && user.support_point_user
        notify_user_by_email_about_paid_order
      end
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
      Multilevel::SponsorQualifierService.call(user: user)
    end

    def create_order_payment
      order.paid!
      Financial::OrderPaymentService.call(order: order) if enabled_bonification
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
      attributes.merge!(bought_adhesion: true, balance_unlocked_at: Time.zone.now) if adhesion_product
      attributes.merge!(bought_product: true) if regular_product?
      user.update_attributes!(attributes)
    end

    def upgrade_career_from(user)
      UpgraderCareerService.call(user: user)
    end

    def upgrade_user_trail
      trail = adhesion_product.try(:trail)
      UpgraderTrailService.call(user: user, new_trail: trail) if trail
    end

    def activate_user
      user.activate!
    end

    def activate_user_until!
      reference_date = user.active? ? user.active_until : Date.current
      user.activate!(reference_date + 1.month)
    end

    def update_user_role
      user.update_attributes!(role: 'empreendedor')
    end

    def binary_bonus_nodes_verifier
      NodesBinaryBonusVerifierWorker.perform_async(order.user.binary_node.id)
    end

    def create_next_activation_order
      Financial::CreatorActivationOrderService.call(user: user)
    end

    def associate_support_point
      AssociateSupportPointService.call(user: order.user)
    end

    def add_product_bonus_to_order
      product_bonus = user.current_trail.product_bonus
      order.order_items.create!(quantity: 1,
                                product: product_bonus) if product_bonus
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

    def activation_product
      @activation_product ||= order.products.detect(&:activation?)
    end

    def new_trail?
      user.current_trail != adhesion_product.try(:trail)
    end

    def upgraded_trail?
      user.bought_adhesion && new_trail?
    end

    def inside_binary_tree?
      user.binary_node
    end

    def notify_user_by_email_about_paid_order
      ShoppingMailer.with(order: order).order_paid.deliver_later
    end

    def validates_code_of?(product)
      return true unless product.code
      activation_product_codes = user.current_career_trail
                                     .activation_product_codes
                                     .to_a
      return true if activation_product_codes.empty?
      product.code.in?(activation_product_codes)
    end

    def enabled_activation?
      ENV['ENABLED_ACTIVATION'] == 'true'
    end

    def enabled_binary?
      ENV['ENABLED_BINARY'] == 'true'
    end

    def create_support_point_activation_bonus
      Bonification::SupportPointActivationService.call(order: order)
    end

  end
end
