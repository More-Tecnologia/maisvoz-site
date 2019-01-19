module Investments
  class Compensate

    def initialize(order:)
      @order = order
      @investment_share = order.payable
    end

    def call
      update_investment_share
      credit_bonus
    end

    private

    attr_reader :order, :investment_share

    def update_investment_share
      investment_share.active!
    end

    def credit_bonus
      Investments::CreditBonus.call(order: order)
    end

  end
end
