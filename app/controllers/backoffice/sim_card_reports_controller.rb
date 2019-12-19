module Backoffice
  class SimCardReportsController < BackofficeController

    def index
      @q = SimCard.ransack(search_params)
      @sim_cards = @q.result.page(params[:page])
    end

    private

    def search_params
      query_params = params[:q] || {}
      user_params =
        current_user.support_point? ? { support_point_user_id_eq: current_user.id } : { user_id_eq: current_user.id }
      query_params.merge!(user_params)
    end

  end
end
