module Backoffice
  module Admin
    class FinancialTransactionsController < BackofficeController
      def index
        authorize :admin_financial_entries, :index?
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = @q.result(distinct: true)
                                   .includes_associations
                                   .page(params[:page])
        render 'backoffice/financial_transactions/index'
      end
    end
  end
end
