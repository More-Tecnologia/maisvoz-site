module Backoffice
  module Admin
    class BonusEntriesController < AdminController

      def index
        render(:index, locals: { bonus_entries: bonus_entries })
      end

      private

      def bonus_entries
        BonusQuery.new.call(params)
      end

    end
  end
end
