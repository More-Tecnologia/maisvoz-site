module Backoffice
  class BonusEntriesController < BackofficeController

    def index
      render(:index, locals: { bonus_entries: bonus_entries })
    end

    private

    def bonus_entries
      FinancialEntry.where(kind: :binary_bonus, to: current_user.account).page(params[:page])
    end

  end
end
