module Backoffice
  class SimCardReportsController < BackofficeController

    def index
      @q = SimCard.ransack(query_params)
      @sim_cards = @q.result
                     .order(created_at: :desc)
                     .page(params[:page])
    end

    private

    def query_params
      query = params[:q] || {}
      query.merge(user_id_or_support_point_user_id_eq: current_user.id)
    end

  end
end
