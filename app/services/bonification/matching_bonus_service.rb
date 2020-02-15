module Bonification
  class MatchingBonusService < ApplicationService

    BONUS_COMMISSIONS =
      [[0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
       [0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
       [0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
       [0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5]]

    def call
      return unless @binary_bonus.to_f.positive?
      sponsors.each_with_index do |sponsor, index|
        generation = index + 1
        amount = calculate_binary_bonus_commission(sponsor.current_career.id, generation)
        create_matching_bonus_for(sponsor, generation, amount) if amount.positive? && sponsor.empreendedor?
      end
    end

    private

    def initialize(args)
      @user = args[:user]
      @unilevel_node = @user.unilevel_node
      @binary_bonus = args[:binary_bonus]
    end

    def create_matching_bonus_for(sponsor, generation, amount)
      transaction =
        sponsor.financial_transactions
               .create!(cent_amount: amount,
                        spreader: User.find_morenwm_customer_admin,
                        financial_reason: FinancialReason.matching_bonus,
                        generation: generation)
      chargeback_by_inactivity!(transaction) unless sponsor.active?
    end

    def sponsors
      @sponsors ||= @unilevel_node.ancestors
                                  .bonus_receivers(BONUS_COMMISSIONS.length)
                                  .map(&:user)
    end

    def chargeback_by_inactivity(transaction)
      financial_reason = FinancialReason.matching_bonus_chargeback_by_inactivity
      transaction.chargeback_by_inactivity!(financial_reason)
    end

    def calculate_binary_bonus_commission(career_id, generation)
      row = BONUS_COMMISSIONS[generation - 1]
      commission = row ? row[career_id - 1] : 0
      @binary_bonus * (commission.to_f / 100.0)
    end

  end
end
