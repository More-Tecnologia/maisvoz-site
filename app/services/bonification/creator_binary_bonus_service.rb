module Bonification
  class CreatorBinaryBonusService < ApplicationService

    def call
      return unless valid_to_receive_bonus?
      ActiveRecord::Base.transaction do
        transaction = credit_binary_bonus
        return transaction.chargeback_by_inactivity! if user.inactive?
        transaction.chargeback_by_career_trail_excess!(career_trail_excess_bonus) if career_trail_excess_bonus > 0
      end
    end

    private

    attr_reader :binary_node, :binary_bonus_entry, :user

    def initialize(binary_node)
      @binary_node = binary_node
      @user        = binary_node.user
    end

    def valid_to_receive_bonus?
      user.binary_qualified? &&
      user.current_career &&
      binary_node.reached_minimum_score_paid?
    end

    def credit_binary_bonus
      financial_transaction = create_bonus
      Score.debit_shortter_leg_score_from(user)
      financial_transaction
    end

    def create_bonus
      user.financial_transactions.create!(financial_reason: FinancialReason.binary_bonus,
                                          cent_amount: binary_bonus)
    end

    def binary_bonus
      @binary_bonus ||= (shortter_leg_score * binary_percent).to_i
    end

    def binary_percent
      user.current_trail.product.binary_bonus_percent
    end

    def shortter_leg_score
      @shortter_leg_score ||= binary_node.shortter_leg_score
    end

    def current_week_bonus
      @current_week_bonus ||= WeeklyBinaryBonusReceivedQuery.new(user).call
    end

    def calculate_weekly_bonus_excess
      return 0 unless user.current_career.weekly_maximum_binary_score
      weekly_maximum_binary_bonus =
        user.current_career.weekly_maximum_binary_score.to_f * binary_percent
      current_week_bonus - weekly_maximum_binary_bonus
    end

    def weekly_bonus_excess
      @weekly_bonus_excess ||= calculate_weekly_bonus_excess
    end

    def current_month_bonus
      @current_month_bonus ||=
        FinancialTransactionPolicy.new(user).current_month_bonus
    end

    def calculate_monthly_bonus_excess
      return 0 unless user.current_career.monthly_maximum_binary_score
      monthly_maximum_binary_bonus =
        user.current_career.monthly_maximum_binary_score.to_f * binary_percent
      current_month_bonus - monthly_maximum_binary_bonus
    end

    def monthly_bonus_excess
      @monthly_bonus_excess ||= calculate_monthly_bonus_excess
    end

    def career_trail_excess_bonus
      @career_trail_excess_bonus ||= user.calculate_excess_career_trail_bonus
    end

  end
end
