module Backoffice::Admin
  class FinancialReportsController < AdminController
    def index
      @q = FinancialReport.ransack(params[:q])
      @financial_reports = @q.result
                             .order(created_at: :desc)
                             .page(params[:page])

    end

    def update; end
  end
end
