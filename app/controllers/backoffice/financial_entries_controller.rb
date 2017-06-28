module Backoffice
  class FinancialEntriesController < AdminController

    def index
      render(:index, locals: { financial_entries: financial_entries })
    end

    private

    def financial_entries
      AccountFinancialEntriesQuery.new(current_user.account).call.page(params[:page])
    end

  end
end
