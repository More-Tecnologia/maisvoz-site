module Financial
  class CreatorSystemFeeService < ApplicationService
    def call
      FinancialTransaction.create!(user: User.find_morenwm_user,
                                   spreader: order.user,
                                   financial_reason: FinancialReason.morenwm_fee,
                                   cent_amount: amount,
                                   order: order) if amount > 0
    end

    private

    attr_reader :order, :amount

    def initialize(args)
      @order = args[:order]
      @amount = calculate_amount_fee
    end

    def calculate_amount_fee
      amount = order.taxable_product_cent_amount.to_i
      amount *= ENV['SYSTEM_FEE'].to_d
      amount.to_i
    end
  end
end
