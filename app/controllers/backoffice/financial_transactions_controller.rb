module Backoffice
  class FinancialTransactionsController < EntrepreneurController
    include Backoffice::FinancialTransactionsHelper

    def index
      if current_user.empreendedor?
        @financial_transactions =
          FinancialTransaction.by_current_user(current_user)
                              .to_empreendedor
                              .includes(:spreader, :financial_reason, :order)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(10)
      else
        @q = FinancialTransaction.ransack(params[:q])
      @financial_transactions = find_financial_transactions_by_current_user(@q)
      end
    end
  end
end
