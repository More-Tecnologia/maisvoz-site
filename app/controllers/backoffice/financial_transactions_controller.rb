module Backoffice
  class FinancialTransactionsController < EntrepreneurController

    include Backoffice::FinancialTransactionsHelper

    before_action :ensure_admin_or_entrepreneur

    def index
      @q = FinancialTransaction.ransack(params[:q])
      @financial_transactions = find_financial_transactions_by_current_user(@q)
    end

  end
end
