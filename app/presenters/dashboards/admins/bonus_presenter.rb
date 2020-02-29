# frozen_string_literal: true

module Dashboards
  module Admins
    class BonusPresenter

      BINARY = FinancialReason.binary_bonus
      BINARY_CHARGEBACK = FinancialReason.binary_bonus
      DIRECT = FinancialReason.direct_commission_bonus
      DIRECT_CHARGEBACK = FinancialReason.direct_commission_bonus_chargeback
      MATCHING = FinancialReason.matching_bonus
      MATCHING_CHARGEBACK = FinancialReason.matching_bonus
      POOL_TRADE = FinancialReason.pool_tranding
      POOL_TRADE_CHARGEBACK = FinancialReason.pool_tranding
      RESIDUAL = FinancialReason.residual_bonus
      RESIDUAL_CHARGEBACK = FinancialReason.residual_bonus

      def initialize
        @financial_transactions = FinancialTransaction.to_customer_admin.with_active_bonus
        @chargeback = @financial_transactions.debit
        @bonus = @financial_transactions.credit
      end

      def build
        {
          data: { bonus: bonus },
          labels: labels
        }
      end

      private

      def bonus
        {
          binary: bonus_calculation(BINARY, BINARY_CHARGEBACK),
          total_bonus: total_bonus,
          direct_commission: bonus_calculation(DIRECT, DIRECT_CHARGEBACK),
          matching: bonus_calculation(MATCHING, MATCHING_CHARGEBACK),
          pool_trade: bonus_calculation(POOL_TRADE, POOL_TRADE_CHARGEBACK),
          residual: bonus_calculation(RESIDUAL, RESIDUAL_CHARGEBACK),
          chargebacks: @chargeback.sum(&:cent_amount),
          gross_bonus: @bonus.sum(&:cent_amount)
        }
      end

      def bonus_calculation(bonus_type, chargeback_type)
        @bonus.by_bonus(bonus_type)
              .sum(&:cent_amount) - @chargeback.by_bonus(chargeback_type)
                                               .sum(&:cent_amount)
      end

      def labels
        {
          binary: I18n.t(:binary),
          chargebacks: I18n.t(:chargebacks),
          direct_commission: I18n.t(:direct_commission_bonus),
          matching: I18n.t(:matching_bonus),
          pool_trade: I18n.t(:pool_trade_bonus),
          residual: I18n.t(:residual_bonus),
          total_bonus: I18n.t(:total_bonus)
        }
      end

      def total_bonus
        @bonus.sum(&:cent_amount) - @chargeback.sum(&:cent_amount)
      end

    end
  end
end
