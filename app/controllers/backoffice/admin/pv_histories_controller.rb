module Backoffice
  module Admin
    class PvHistoriesController < AdminController

      def index
        render(:index, locals: { pv_histories: pv_histories })
      end

      private

      def pv_histories
        PvHistoriesQuery.new.call(params)
      end

    end
  end
end
