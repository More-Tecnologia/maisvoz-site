module Financial
  class OrderPaymentService < ApplicationService
    def call
      FinancialTransaction.create!(
        user: User.find_morenwm_customer_admin,
        spreader: order.user,
        financial_reason: FinancialReason.order_payment,
        cent_amount: total,
        order: order
      )
    end

    private

    attr_reader :order

    def initialize(args)
      @order = args[:order]
    end

    def total
      order.total_cents / 100.0
    end
  end
end
