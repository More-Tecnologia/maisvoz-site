module Investments
  class CreditBonus

    DIRECT_BONUS = 0.05
    INDIRECT_BONUS = 0.015

    prepend SimpleCommand

    def initialize(order:)
      @order = order
      @investment_share = order.payable
    end

    def call
      return unless investment_share.active?

      credit_direct_bonus
      credit_indirect_bonus_one
      credit_indirect_bonus_two
    end

    private

    attr_reader :order, :investment_share

    delegate :user, to: :investment_share

    def credit_direct_bonus
      Bonification::Credit.call(
        user: sponsor,
        order: order,
        bonus_amount: direct_bonus_amount,
        kind: FinancialEntry.kinds[:direct_captation_bonus],
        description: "Bônus de captação direta do usuário #{user.username}"
      )
    end

    def credit_indirect_bonus_one
      Bonification::Credit.call(
        user: sponsor_lvl_one,
        order: order,
        bonus_amount: indirect_bonus_amount,
        kind: FinancialEntry.kinds[:indirect_captation_bonus],
        description: "Bônus de captação indireta do usuário #{user.username}"
      )
    end

    def credit_indirect_bonus_two
      Bonification::Credit.call(
        user: sponsor_lvl_two,
        order: order,
        bonus_amount: indirect_bonus_amount,
        kind: FinancialEntry.kinds[:indirect_captation_bonus],
        description: "Bônus de captação indireta do usuário #{user.username}"
      )
    end

    def sponsor_lvl_one
      return unless sponsor && sponsor.sponsor.present?

      sponsor.sponsor
    end

    def sponsor_lvl_two
      return unless sponsor_lvl_one && sponsor_lvl_one.sponsor.present?

      sponsor_lvl_one.sponsor
    end

    def direct_bonus_amount
      investment_share.gross_amount * DIRECT_BONUS
    end

    def indirect_bonus_amount
      investment_share.gross_amount * INDIRECT_BONUS
    end

    def sponsor
      user.sponsor
    end

  end
end
