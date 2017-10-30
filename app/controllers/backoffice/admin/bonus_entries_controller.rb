module Backoffice
  module Admin
    class BonusEntriesController < AdminController

      def index
        render(:index, locals: { bonus_entries: bonus_entries })
      end

      private

      def bonus_entries
        Bonus.all.page(params[:page])
      end

    end
  end
end
