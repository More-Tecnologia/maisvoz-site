module Backoffice
  module Admin
    class SimCardReportsController < AdminController

      def index
        @q = SimCard.ransack(search_params)
        @sim_cards = @q.result
                       .includes(:support_point_user, :user)
                       .page(params[:page])
      end

      private

      def search_params
        query = params[:q] || {}
        query = query.except(:support_point_stock_out_at_not_null) if query[:support_point_stock_out_at_not_null] == '0'
        query
      end

    end
  end
end
