module Backoffice
  class BonusFinancialTransactionsController < EntrepreneurController

    before_action :ensure_admin_or_entrepreneur

    def index
      @q = FinancialTransaction.ransack(query_params)
      @financial_transactions = @q.result(distinct: true).includes_associations
                                                         .order(created_at: :desc)
                                                         .page(params[:page])
      render 'backoffice/financial_transactions/index'
    end

    private

    def query_params
      query = params[:q] ? params[:q] : {}
      query.merge(user_id_eq: current_user.id,
                  financial_reason_id_in: FinancialReason.bonus.pluck(:id))
    end

  end
end
