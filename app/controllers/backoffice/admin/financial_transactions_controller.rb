module Backoffice
  module Admin
    class FinancialTransactionsController < BackofficeController
      include Backoffice::FinancialTransactionsCsvHelper

      def index
        authorize :admin_financial_entries, :index?

        respond_to do |format|
          format.html { @financial_transactions = financial_transactions.page(params[:page]) }
          format.csv { render_transactions_as_csv(financial_transactions) }
        end
      end

      private

      def financial_transactions
        @q = FinancialTransaction.ransack(params[:q])
        @q.result
          .includes(:user, :spreader, :order, :financial_reason)
          .order(created_at: :desc)
      end
    end
  end
end
