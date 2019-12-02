module Backoffice
  module Admin
    class BonusFinancialTransactionsController < AdminController
      def index
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = @q.result(distinct: true)
                                    .financial_reason_bonus
                                    .order(created_at: :desc)
                                    .page(params[:page])
        render 'backoffice/financial_transactions/index'
      end
    end
  end
end
