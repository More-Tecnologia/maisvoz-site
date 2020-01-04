module Backoffice
  module Admin

    class FinancialReportController < AdminController

      def index
        @q = FinancialTransaction.ransack(params[:q])
        @financial_transactions = @q.result
                                    .includes(:user, :spreader, :order, financial_reason: [:financial_reason_type])
                                    .order(created_at: :desc)
                                    .page(params[:page])
      end

    end

  end
end
