module Backoffice
  class FinancialTransactionsController < EntrepreneurController
    before_action :ensure_admin_or_entrepreneur

    def index
      @q = FinancialTransaction.ransack(params[:q])
      @financial_transactions = @q.result(distinct: true)
                                  .by_user(current_user)
                                  .page(params[:page])
    end

    private

    def ensure_admin_or_entrepreneur
      return if signed_in? && (current_user.admin? || current_user.empreendedor?)
      flash[:error] = 'Você precisa ser admin ou empreendedor'
      redirect_to root_path
    end
  end
end
