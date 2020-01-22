module Financial
  class CreatorSystemFeeService < ApplicationService

    def call
      user = User.find_morenwm_user
      user.financial_transactions.create!(spreader: order.user,
                                          financial_reason: FinancialReason.morenwm_fee,
                                          cent_amount: amount,
                                          order: order,
                                          moneyflow: :debit) if amount > 0
    end

    private

    attr_reader :order, :amount

    def initialize(args)
      @order = args[:order]
      @amount = calculate_amount_fee
    end

    def calculate_amount_fee
      order_value = order.taxable_product_cent_amount.to_f
      order_value * ENV['SYSTEM_FEE'].to_d
    end

  end
end
