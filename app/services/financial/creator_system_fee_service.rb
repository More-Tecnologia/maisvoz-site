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
      @order_items = @order.order_items
      @amount = calculate_amount_fee
    end

    def calculate_amount_fee
      order_value = @order_items.sum { |i| i.product.system_taxable ? i.amount : 0 }
      order_value * ENV['SYSTEM_FEE'].to_d
    end

  end
end
