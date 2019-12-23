module Bonification
  class CreatorBinaryBonusService < ApplicationService

    def call
      return unless binary_bonus_score > 0 && valid_binary_bonus > 0
      ActiveRecord::Base.transaction do
        transaction = credit_binary_bonus
        return transaction.chargeback_by_inactivity! if user.inactive?
        return transaction.chargeback_by_unqualification! if user.binary_unqualified?
        transaction.chargeback_by_career_trail_excess!(career_trail_excess_bonus) if career_trail_excess_bonus > 0
        Financial::UnlockBlockedBalance.call(user: ascendant_sponsor)
      end
    end

    private

    attr_reader :binary_node, :user, :score_cycle, :binary_bonus_score

    def initialize(binary_node)
      @binary_node = binary_node
      @user        = binary_node.user
      @score_cycle = ENV['BINARY_SCORE_MINIMUM_PAID'].to_i
      @binary_bonus_score = shortter_leg_score.div(score_cycle) * score_cycle
    end

    def credit_binary_bonus
      financial_transaction = create_bonus
      Score.debit_binary_score_from_legs(user, binary_bonus_score)
      financial_transaction
    end

    def create_bonus
      user.financial_transactions.create!(financial_reason: FinancialReason.binary_bonus,
                                          cent_amount: valid_binary_bonus,
                                          spreader: User.find_morenwm_customer_admin)
    end

    def valid_binary_bonus
      @valid_binary_bonus ||= user.current_trail.calculate_binary_bonus(binary_bonus_score)
    end

    def binary_percent
      user.current_trail.product.binary_bonus_percent
    end

    def shortter_leg_score
      @shortter_leg_score ||= binary_node.shortter_leg_score
    end

    def career_trail_excess_bonus
      @career_trail_excess_bonus ||= user.calculate_excess_career_trail_bonus
    end

    def ensure_cycle_score
      ENV['BINARY_SCORE_MINIMUM_PAID'].to_i
    end

  end
end