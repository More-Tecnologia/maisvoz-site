module Backoffice
  module Admin
    class PvActivityHistoriesController < AdminController

      def index
        render(:index, locals: { pv_activity_histories: pv_activity_histories })
      end

      private

      def pv_activity_histories
        PvActivityHistoriesQuery.new.call(params)
      end

    end
  end
end
