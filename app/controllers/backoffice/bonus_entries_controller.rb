module Backoffice
  class BonusEntriesController < EntrepreneurController

    def index
      render(:index, locals: { bonus_entries: bonus_entries })
    end

    private

    def bonus_entries
      BonusQuery.new(current_user.financial_entries).call(params).includes(order: :user)
    end

  end
end
