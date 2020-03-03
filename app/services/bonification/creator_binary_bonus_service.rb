module Bonification
  class CreatorBinaryBonusService < ApplicationService

    def call
      return unless @valid_score >= ENV['BINARY_SCORE_MINIMUM_PAID'].to_i && @daily_valid_bonus > 0
      ActiveRecord::Base.transaction do
        transaction = credit_binary_bonus
        return transaction.chargeback_by_inactivity! if user.inactive?
        return transaction.chargeback_by_unqualification! if user.binary_unqualified?
        transaction.binary_bonus_chargeback_by_daily_excees(@daily_excess_bonus) if @daily_excess_bonus > 0
        create_matching_bonus_for_user
      end
    end

    private

    attr_reader :binary_node, :user

    def initialize(args)
      @binary_node = args[:binary_node]
      @user = @binary_node.user
      @daily_bonus_total = ENV['BINARY_BONUS_SCORE_RATE'].to_f * shortter_leg_score_from_yesterday
      @daily_excess_bonus = ENV['BINARY_BONUS_SCORE_RATE'].to_f * calculate_daily_excess_score
      @daily_valid_bonus = @daily_bonus_total - @daily_excess_bonus
      @valid_score = @daily_valid_bonus / ENV['BINARY_BONUS_SCORE_RATE'].to_f
    end

    def credit_binary_bonus
      financial_transaction = create_bonus
      Score.debit_binary_score_from_legs(user, @valid_score)
      financial_transaction
    end

    def create_bonus
      user.financial_transactions.create!(financial_reason: FinancialReason.binary_bonus,
                                          cent_amount: @daily_valid_bonus,
                                          spreader: User.find_morenwm_customer_admin)
    end

    def shortter_leg_score_from_yesterday
      @shortter_leg_score_from_yesterday ||= [right_leg_score_from_yesterday, left_leg_score_from_yesterday].compact.min
    end

    def left_leg_score_from_yesterday
      @left_leg_score_from_yesterday ||= user.scores.binary.left.backward.sum(:cent_amount)
    end

    def right_leg_score_from_yesterday
      @right_leg_score_from_yesterday ||= user.scores.binary.right.backward.sum(:cent_amount)
    end

    def calculate_daily_excess_score
      daily_maximum_bonus = @user.current_career_trail.maximum_bonus.to_f
      shortter_leg_score_from_yesterday - daily_maximum_bonus
    end

    def create_matching_bonus_for_user
      Bonification::MatchingBonusService.call(user: @user, binary_bonus: @daily_valid_bonus)
    end

  end
end
