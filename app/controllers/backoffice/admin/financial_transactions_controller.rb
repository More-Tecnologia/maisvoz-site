module Backoffice
  module Admin
    class FinancialTransactionsController < BackofficeController

      def index
        authorize :admin_financial_entries, :index?
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = @q.result.includes_associations
                                           .order(created_at: :desc)
                                           .page(params[:page])
        render 'backoffice/financial_transactions/index'
      end

    end
  end
end
