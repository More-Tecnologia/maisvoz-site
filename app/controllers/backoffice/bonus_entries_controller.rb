module Backoffice
  class BonusEntriesController < BackofficeController

    def index
      render(:index, locals: { bonus_entries: bonus_entries })
    end

    private

    def bonus_entries
      @bonus_entries ||= current_user.bonus.page(params[:page])
    end

  end
end
