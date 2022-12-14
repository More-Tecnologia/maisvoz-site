module Backoffice
  class FinancialTransactionsController < EntrepreneurController
    include Backoffice::FinancialTransactionsHelper

    FINANCIAL_REASONS = {
      chargeback_by_inactivity: FinancialReason.chargeback_by_inactivity,
      chargeback_by_max_task_gains: FinancialReason.chargeback_by_max_gains,
      direct_referral_bonus: FinancialReason.direct_commission_bonus,
      indirect_referral_bonus: FinancialReason.indirect_referral_bonus,
      master_leader_bonus: FinancialReason.master_leader_bonus,
      order_payment_with_balance: FinancialReason.order_payment_with_balance,
      recurrent_bonus: FinancialReason.matching_bonus,
      task_performed: FinancialReason.yield_bonus,
      raffles_direct_commission_bonus: FinancialReason.raffles_direct_commission_bonus
    }
    
    def index
      if current_user.empreendedor? || current_user.consumidor?
        @financial_transactions =
          FinancialTransaction.by_current_user(current_user)
                              .to_empreendedor
                              .includes(:spreader, :financial_reason, :order)
                              .where(financial_reason: ensure_financial_reason)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
      else
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = find_financial_transactions_by_current_user(@q)
      end
    end

    private

    def ensure_financial_reason
      if params[:financial_reason].present?
        FINANCIAL_REASONS[params[:financial_reason].to_sym]
      else
        FinancialReason.all
      end
    end
  end
end
