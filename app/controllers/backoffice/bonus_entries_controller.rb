module Backoffice
  class BonusEntriesController < AdminController

    def index
      render(:index, locals: { financial_entries: financial_entries })
    end

    private

    def financial_entries
      current_user.financial_entries.page(params[:page])
    end

  end
end
