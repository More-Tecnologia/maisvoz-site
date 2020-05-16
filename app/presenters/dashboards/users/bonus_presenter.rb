# frozen_string_literal: true

module Dashboards
  module Users
    class BonusPresenter

      DIRECT = FinancialReason.direct_commission_bonus
      DIRECT_CHARGEBACK = FinancialReason.direct_commission_bonus_chargeback
      INDIRECT = FinancialReason.indirect_referral_bonus
      INDIRECT_CHARGEBACK = FinancialReason.indirect_referral_bonus_chargeback_by_inactivity
      YIELD = FinancialReason.yield_bonus
      YIELD_CHARGEBACK = nil

      def initialize(user)
        @user = user
        @financial_transactions = FinancialTransaction.by_current_user(@user)
                                                      .to_empreendedor
                                                      .with_active_bonus
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
          direct_referral: bonus_calculation(DIRECT, DIRECT_CHARGEBACK),
          indirect_referral: bonus_calculation(INDIRECT, INDIRECT_CHARGEBACK),
          yield: bonus_calculation(YIELD, YIELD_CHARGEBACK),
          total_bonus: total_bonus,
          chargebacks: (@chargeback.sum(:cent_amount) / 1e8.to_f).round(2),
          gross_bonus: (@bonus.sum(:cent_amount) / 1e8.to_f).round(2)
        }
      end

      def bonus_calculation(bonus_type, chargeback_type)
        bonus = @bonus.by_bonus(bonus_type)
                      .sum(:cent_amount) - @chargeback.by_bonus(chargeback_type)
                                                      .sum(:cent_amount)
        (bonus / 1e8.to_f).round(2)
      end

      def labels
        {
          chargebacks: I18n.t(:chargebacks),
          direct_referral: I18n.t(:direct_referral),
          indirect_referral: I18n.t(:indirect_referral),
          yield: I18n.t(:yield),
          total_bonus: I18n.t(:total_bonus)
        }
      end

      def total_bonus
        sum = @bonus.sum(:cent_amount) - @chargeback.sum(:cent_amount)
        (sum / 1e8.to_f).round(2)
      end

    end
  end
end
