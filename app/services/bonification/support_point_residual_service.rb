module Bonification
  class SupportPointResidualService < ApplicationService

    PERCENTAGE = 0.01.freeze

    def call
      support_points = User.support_point
      support_points.each do |support_point|
        create_residual_bonus_for(support_point) if support_point.empreendedor?
      end
    end

    private

    attr_accessor :residual_bonus

    def initialize
      @residual_bonus = FinancialReason.support_point_residual_bonus
    end

    def create_residual_bonus_for(support_point)
      cent_amount = sum_residual_bonus_for(support_point.supported_point_users)
      byebug
      support_point.financial_transactions
                   .at_last_month
                   .create!(spreader: User.find_morenwm_customer_admin,
                            financial_reason: residual_bonus,
                            cent_amount: cent_amount.to_f * PERCENTAGE) if cent_amount.to_i > 0
    end

    def sum_residual_bonus_for(users)
      credit = FinancialReason.residual_bonus
                              .financial_transactions
                              .where('financial_transactions.user_id': users)
                              .credit
      debit = FinancialReason.residual_bonus
                             .financial_transactions
                             .where('financial_transactions.user_id': users.map(&:id))
                             .debit
      (credit - debit) / 1e8.to_f
    end

  end
end
