module Backoffice
  module Admin
    class FinancialTransactionsController < BackofficeController

      def index
        authorize :admin_financial_entries, :index?
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = @q.result
                                    .includes(:user, :spreader, :order, :financial_reason)
                                    .order(created_at: :desc)
                                    .page(params[:page])
      end

    end
  end
end
