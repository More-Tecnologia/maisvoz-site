module Backoffice
  class FinancialTransactionsController < EntrepreneurController
    include Backoffice::FinancialTransactionsHelper

    def index
      @q = FinancialTransaction.ransack(params[:q])
      @financial_transactions = find_financial_transactions_by_current_user(@q)
    end
  end
end
