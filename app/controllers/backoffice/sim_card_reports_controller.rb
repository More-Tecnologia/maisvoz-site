module Backoffice
  class SimCardReportsController < BackofficeController

    def index
      @q = SimCard.ransack(params[:q])
      @sim_cards = @q.result.by_user(current_user)
                            .by_support_point(current_user)
                            .order(created_at: :desc)
                            .page(params[:page])
    end

  end
end
