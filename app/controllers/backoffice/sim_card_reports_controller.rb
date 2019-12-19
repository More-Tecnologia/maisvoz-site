module Backoffice
  class SimCardReportsController < BackofficeController

    def index
      @q = SimCard.ransack(search_params)
      @sim_cards = @q.result.page(params[:page])
    end

    private

    def search_params
      query_params = params[:q] || {}
      if current_user.support_point?
        query_params.merge!(support_point_user_id_eq: current_user.id)
        query_params.slice!(:support_point_stock_out_at_not_null) if query_params[:support_point_stock_out_at_not_null] == '0'
        query_params.slice!(:support_point_stock_out_at_null) if query_params[:support_point_stock_out_at_null] == '0'
      else
        query_params.merge!(user_id_eq: current_user.id)
        query_params.slice!(:user_stock_out_at_not_null) if query_params[:user_stock_out_at_not_null] == '0'
        query_params.slice!(:user_stock_out_at_null) if query_params[:user_stock_out_at_null] == '0'
      end
      query_params
    end

  end
end
