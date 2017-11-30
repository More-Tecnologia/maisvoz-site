module Backoffice
  class FinancialEntriesController < BackofficeController

    def index
      render(:index, locals: { financial_entries: financial_entries })
    end

    private

    def financial_entries
      AccountFinancialEntriesQuery.new(current_user).call.page(params[:page])
    end

  end
end
