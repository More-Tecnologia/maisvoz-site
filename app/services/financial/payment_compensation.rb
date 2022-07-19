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
        create_bonus_first_buy if first_buy_products? && first_buy? && deposit_product
        create_free_product_bonus if free_product
        transform_free_bonus if eligible_for_free_bonus? && free_product_counting? && free_bonus_elegible_sponsor?
        create_order_payment
        upgrade_user_trail if upgraded_trail?
        update_user_purchase_flags
        activate_user if (deposit_product || free_product)
        activate_user_until! if activation_product && validates_code_of?(activation_product) && enabled_activation?
        user.empreendedor! if (deposit_product || free_product) && user.consumidor?
        insert_into_binary_tree if user.out_binary_tree? && adhesion_product
        qualify_sponsor if !user.sponsor_is_binary_qualified? && user.active && enabled_binary?
        create_pool_point_for_user if enabled_bonification
        propagate_binary_score if enabled_bonification && enabled_binary?
        propagate_products_scores if enabled_bonification
        upgrade_career_from(user.sponsor)
        upgrade_career_from(user) if deposit_product
        add_promotional_bonus if deposit_product
        propagate_bonuses if enabled_bonification
        propagate_course_payment if course_product
        create_vouchers if voucher_product
        create_bonus_contract if deposit_product || free_product
        process_reserved_raffle_tickets if raffle_product
        propagate_raffle_bonus_payment if raffle_product && enabled_bonification
        propagate_master_bonus if deposit_product
        enroll_student_on_course if course_product
        create_system_fee if order.products.any?(&:system_taxable) && enabled_bonification
        remove_user_from_free_product_list if order.total_cents.positive? && user.interspire_code.present?
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
      return if order.balance?

      Financial::OrderPaymentService.call(order: order,
                                          enabled_bonification: enabled_bonification)
    end

    def propagate_binary_score
      Bonification::Propagator::BinaryScoreService.call(order: order)
    end

    def propagate_products_scores
      Bonification::AdhesionProductScorePropagator.call(order: order) if adhesion_product
      Bonification::DetachedProductScorePropagator.call(order: order)
      Bonification::ActivationProductScorePropagator.call(order: order)
      Bonification::DepositProductScorePropagator.call(order: order)
    end

    def propagate_bonuses
      Bonification::BonusPropagatorService.call(order: order)
    end

    def propagate_course_bonus
      Bonification::CourseDirectIndirectCreatorService.call(user: order.user, amount: order.total)
    end

    def propagate_master_bonus
      MasterLeaderCreatorWorker.perform_async(order.id)
    end

    def propagate_course_payment
      order.order_items.each do |order_item|
        date = Time.now + Course.days_to_cashbacks[order_item.product.course.days_to_cashback].days
        CourseSalePaymentWorker.perform_at(date, order_item.id)
        CourseDirectIndirectWorker.perform_at(date, order.user.id, order_item.total_cents)
      end
    end

    def propagate_raffle_bonus_payment
      order.order_items.each do |order_item|
        if order_item.raffle_ticket.present?
         RafflesDirectWorker.perform_async(order_item.raffle_ticket.id)
        end
      end
    end

    def enroll_student_on_course
      Courses::EnrollStudentService.call(student: order.user, courses: order.products.map(&:course))
    end

    def create_vouchers
      Vouchers::Create.new(user: user, order: order).call
    end

    def create_system_fee
      Financial::CreatorSystemFeeService.call(order: order)
    end

    def first_buy?
      user.orders
          .joins(order_items: :product)
          .where(order_items: { product: Product.deposit })
          .completed
          .none?
    end

    def first_buy_products?
      order.order_items
           .includes(:product)
           .where(products: { code: [1, 2, 3, 4]})
           .any?
    end

    def create_bonus_first_buy
      user.increment(:brute_promotional_balance, SharedHelper::FIRST_BUY_BONUS_AMOUNT_BY_PRODUCTS[order.order_items.last.product.code])
      user.increment(:promotional_balance, SharedHelper::FIRST_BUY_BONUS_AMOUNT_BY_PRODUCTS[order.order_items.last.product.code]).save!
    end

    def create_free_product_bonus
      user.increment(:brute_promotional_balance, SharedHelper::FREE_PRODUCT_BONUS_AMOUNT)
      user.increment(:promotional_balance, SharedHelper::FREE_PRODUCT_BONUS_AMOUNT).save!
    end

    def process_reserved_raffle_tickets
      order.order_items.each do |order_item|
        if order_item.raffle_ticket.present?
          ProcessReservedRaffleTicketWorker.perform_async(order_item.raffle_ticket
                                                                    .id)
        else
          user.financial_transactions
              .create(spreader: User.find_morenwm_customer_admin,
                      financial_reason: FinancialReason.credit_for_payment_of_expired_order,
                      cent_amount: (order_item.total_cents / 100),
                      moneyflow: :credit)
        end
      end
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

    def create_next_activation_order
      Financial::CreatorActivationOrderService.call(user: user)
    end

    def add_promotional_bonus
      user.increment(:brute_promotional_balance, (@order.total_cents / 100))
      user.increment(:promotional_balance, (@order.total_cents / 100)).save!
    end

    def add_product_bonus_to_order
      product_bonus = user.current_trail.product_bonus
      order.order_items.create!(quantity: 1,
                                product: product_bonus) if product_bonus
    end

    def free_bonus_elegible_sponsor?
      user.sponsor.created_at + SharedHelper::FREE_BONUS_USER_CREATION_SPAN >= Time.now
    end

    def free_product_counting?
      order.products
           .where('products.price_cents >  5000')
           .where(products: { kind: :deposit })
           .any?
    end

    def eligible_for_free_bonus?
      Order.joins(:products)
           .where(user: (user.sponsor.sponsored.active.select(:id) - [user]))
           .where('products.price_cents >  5000')
           .where(products: { kind: :deposit })
           .any?
    end

    def transform_free_bonus
      sponsor = user.sponsor
      if sponsor.promotional_balance >= SharedHelper::FREE_PRODUCT_BONUS_AMOUNT
        sponsor.decrement(:promotional_balance, SharedHelper::FREE_PRODUCT_BONUS_AMOUNT).save!
        sponsor.financial_transactions
               .create(spreader: User.find_morenwm_customer_admin,
                       financial_reason: FinancialReason.credit_for_payment_by_first_buy,
                       cent_amount: SharedHelper::FREE_PRODUCT_BONUS_AMOUNT,
                       moneyflow: :credit)
      else
        remaning_balance = sponsor.promotional_balance
        sponsor.decrement(:promotional_balance, remaning_balance).save!
        sponsor.financial_transactions
               .create(spreader: User.find_morenwm_customer_admin,
                       financial_reason: FinancialReason.credit_for_payment_by_first_buy,
                       cent_amount: remaning_balance,
                       moneyflow: :credit)
      end
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

    def course_product
      @course_product ||= order.products.detect(&:course?)
    end

    def deposit_product
      @deposit_product ||= order.products.detect(&:deposit?)
    end

    def crypto_product
      @crypto_product ||= order.products.detect(&:crypto?)
    end

    def raffle_product
      @raffle_product ||= order.products.detect(&:raffle?)
    end

    def free_product
      order.products.detect(&:free?)
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

    def create_pool_point_for_user
      Bonification::CreatorPoolPointService.call(order: order)
    end

    def create_bonus_contract
      CreatorBonusContractService.call(order: order, enabled_bonification: enabled_bonification)
    end

    def remove_user_from_free_product_list
      Interspire::ContactDeleterWorker.perform_async(user.email)
    end
  end
end
