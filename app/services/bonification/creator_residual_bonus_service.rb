module Bonification
  class CreatorResidualBonusService < ApplicationService

    COMMISSIONS = [[0, 7, 7, 7, 7, 7, 7],
                   [0, 2, 2, 2, 2, 2, 2],
                   [0, 2, 2, 2, 2, 2, 2],
                   [0, 1, 1, 1, 1, 1, 1],
                   [0, 1, 1, 1, 1, 1, 1]].freeze

    def call
      User.with_children_pool_point_balance.find_each do |user|
        create_residual_bonus_for(user)
      end
    end

    private

    def initialize
      @residual_bonus = FinancialReason.residual_bonus
    end

    def create_residual_bonus_for(user)
      sponsors = find_sponsors_by(user)
      sponsors.each_with_index do |sponsor, index|
        generation = index + 1
        amount = calculate_residual_bonus_commission_by(sponsor, generation)
        sponsor.financial_transactions.create!(financial_reason: @residual_bonus,
                                               amount: amount,
                                               spreader: User.find_morenwm_customer_admin,
                                               generation: generation)
      end
    end

    def find_sponsors_by(user)
      generations_count = COMMISSIONS.size
      user.unilevel_node
          .ancestors
          .bonus_receivers(generations_count)
    end

    def calculate_residual_bonus_commission_by(sponsor, generation)
      commission = find_commission_by(sponsor.current_career, generation)
      user.children_pool_trading_balance * commission
    end

    def find_commission_by(career, generation)
      commissions_by_career = COMMISSIONS[career.id - 1]
      commissions_by_career.nil? ? 0 : commissions_by_career[generation-1].to_f
    end

  end
end
