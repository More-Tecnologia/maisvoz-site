module Bonification
  class PoolTradingService < ApplicationService

    def call
      return unless @commission_percent.try(:amount).to_f > 0
      return unless !@active_bonus_contracts.empty? && @user.active?
      ActiveRecord::Base.transaction do
        pool_trading = create_pool_trading_for_user if amount > 0
        if pool_trading
          block_pool_trading_amount(pool_trading.cent_amount)
          increment_sponsor_children_pool_trading_balance(amount)
        end
      end
    end

    private

    def initialize(args)
      @user = args[:user]
      @active_bonus_contracts = @user.bonus_contracts.active.includes(:order)
      @first_bonus_contract = @active_bonus_contracts.try(:first)
      @commission_percent = args[:commission_percent]
    end

    def create_pool_trading_for_user
      @user.financial_transactions.create!(cent_amount: amount,
                                           financial_reason: FinancialReason.pool_tranding,
                                           spreader: User.find_morenwm_customer_admin)
    end

    def amount
      @amount ||= calculate_pool_tranding_amount
    end

    def calculate_pool_tranding_amount
      orders = @active_bonus_contracts.map(&:order)
      pool_points_amount = @user.scores.pool_point_by(orders).sum(&:cent_amount)
      pool_points_amount * (@commission_percent.amount.to_f / 100.0)
    end

    def block_pool_trading_amount(pool_tranding_amont)
      blocked_pool_tranding = @user.pool_tranding_blocked_balance + pool_tranding_amont
      @user.update!(pool_tranding_blocked_balance: blocked_pool_tranding)
    end

    def increment_sponsor_children_pool_trading_balance(amount)
      @user.sponsor
           .increment!(children_pool_trading_balance: amount)
    end

  end
end
