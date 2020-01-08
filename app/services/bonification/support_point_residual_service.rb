module Bonification
  class SupportPointResidualService < ApplicationService

    PERCENTAGE = 0.01.freeze

    def call
      support_points = User.support_point
      support_points.each do |support_point|
        transaction = create_residual_bonus_for(support_point)
        chargeback_by_inactivity(transaction) if support_point.inactive?
      end
    end

    private

    attr_accessor :residual_bonus

    def initialize
      @residual_bonus = FinancialReason.support_point_residual_bonus
    end

    def create_residual_bonus_for(support_point)
      cent_amount = sum_residual_bonus_of(support_point.supported_point_users)
      support_point.financial_transactions
                   .create!(spreader: User.find_morenwm_customer_admin,
                            financial_reason: residual_bonus,
                            cent_amount: cent_amount.to_f * PERCENTAGE) if cent_amount.to_f > 0
    end

    def sum_residual_bonus_of(users)
      credit = FinancialReason.residual_bonus
                              .financial_transactions
                              .credit
                              .at_last_month
                              .by_current_user(users)
                              .sum(:cent_amount)
      debit = FinancialReason.residual_bonus
                             .financial_transactions
                             .debit
                             .at_last_month
                             .by_current_user(users)
                             .sum(:cent_amount)
      (credit - debit) / 1e8.to_f
    end

    def chargeback_by_inactivity(transaction)
      reason = residual_bonus.chargeback_by_inactivity
      transaction.chargeback_by_inactivity!(reason)
    end

  end
end
