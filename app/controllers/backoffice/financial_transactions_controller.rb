module Backoffice
  class FinancialTransactionsController < EntrepreneurController
    include Backoffice::FinancialTransactionsHelper

    def index
      @financial_transactions =
        FinancialTransaction.by_user(current_user)
                            .to_empreendedor
                            .includes(:spreader, :financial_reason, :order)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(10)
    end
  end
end
