module Backoffice
  class FinancialTransactionsController < EntrepreneurController

    before_action :ensure_admin_or_entrepreneur

    def index
      @q = FinancialTransaction.ransack(query_params)
      @financial_transactions = @q.result(distinct: true)
                                  .includes(:user, :spreader, :financial_reason, :order)
                                  .order(created_at: :desc)
                                  .page(params[:page])
    end

    private

    def query_params
      query = params[:q] ? params[:q] : {}
      query.merge(user_id_eq: current_user.id)
    end

  end
end
