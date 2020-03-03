module Bonification
  class PoolLeadershipService < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        financial_transaction = create_pool_leadership_for_user
        chargeback_by_inactivity(financial_transaction) unless @user.active?
      end
    end

    def initialize(params)
      @user = User.select(:id, :active, :active_until).find(params[:user_id])
    end

    def create_pool_leadership_for_user
      @user.financial_transactions.create!(cent_amount: amount,
                                           financial_reason: FinancialReason.pool_leadership,
                                           spreader: User.find_morenwm_customer_admin)
    end

    def chargeback_by_inactivity(transaction)
      financial_reason = FinancialReason.pool_leadership_chargeback_by_inactivity
      transaction.chargeback_by_inactivity!(financial_reason)
    end

    def amount
      PoolLeadership.current_pool_leadership_value
    end
  end
end
