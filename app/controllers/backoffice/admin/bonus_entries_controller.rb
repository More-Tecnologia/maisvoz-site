module Backoffice
  module Admin
    class BonusEntriesController < BackofficeController

      def index
        authorize :admin_bonus_entries, :index?

        render(
          :index,
          locals: {
            bonus_entries: bonus_entries.page(params[:page]),
            total_amount: total_amount
          }
        )
      end

      private

      def bonus_entries
        @bonus_entries ||= BonusQuery.new.call(params)
      end

      def total_amount
        bonus_entries.sum(:amount_cents) / 1e2
      end

    end
  end
end
