module Backoffice
  module Admin
    class BonusFinancialTransactionsController < AdminController

      def index
        @q = FinancialTransaction.ransack(query_params)
        @financial_transactions = @q.result(distinct: true).order(created_at: :desc)
                                                           .page(params[:page])
        render 'backoffice/financial_transactions/index'
      end

      private

      def query_params
        query = params[:q] ? params[:q] : {}
        query.merge(financial_reason_id_in: FinancialReason.bonus.pluck(:id))
      end

    end
  end
end
