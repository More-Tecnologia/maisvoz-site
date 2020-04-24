module Financial
  class OrderPaymentService < ApplicationService

    def call
      user = User.find_morenwm_customer_admin
      user.financial_transactions.create!(spreader: order.user,
                                          financial_reason: detect_financial_reason,
                                          cent_amount: total,
                                          order: order)
    end

    private

    attr_reader :order

    def initialize(args)
      @order = args[:order]
      @enabled_bonification = args[:enabled_bonification]
    end

    def total
      order.total_cents / 100.0
    end

    def detect_financial_reason
      @enabled_bonification ? FinancialReason.order_payment : FinancialReason.order_sponsored
    end

  end
end
