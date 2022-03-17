module Bonification
  class CourseDirectIndirectCreatorService < ApplicationService
    def call
      sponsors.each_with_index do |sponsor, index|
        next if sponsor.admin?

        transaction = create_bonus_for(sponsor, index + 1)
        if sponsor.inactive?
          chargeback_reason = transaction.financial_reason.chargeback_by_inactivity
          transaction.chargeback_by_inactivity!(chargeback_reason)
        end
      end
    end

    private

    PERCENTAGES = {
                    '1': { commission: 0.30, reason: FinancialReason.course_direct_commission_bonus },
                    '2': { commission: 0.02, reason: FinancialReason.course_indirect_commission_bonus },
                    '3': { commission: 0.01, reason: FinancialReason.course_indirect_commission_bonus },
                    '4': { commission: 0.01, reason: FinancialReason.course_indirect_commission_bonus },
                    '5': { commission: 0.01, reason: FinancialReason.course_indirect_commission_bonus }
                  }.freeze

    def initialize(args)
      @user = args[:user]
      @amount = args[:amount]
    end

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors
                            .bonus_receivers(PERCENTAGES.size)

      unilevel_nodes.is_a?(Array) ? unilevel_nodes.reverse.map(&:user) : [unilevel_nodes.user]
    end

    def create_bonus_for(sponsor, generation)
      data = PERCENTAGES[generation.to_s.to_sym]
      cent_amount = data[:commission] * @amount

      sponsor.financial_transactions
             .create!(spreader: @user,
                     financial_reason: data[:reason],
                     moneyflow: :credit,
                     cent_amount: cent_amount) if cent_amount.positive?
    end
  end
end
