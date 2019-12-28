module Backoffice
  class SimCardTransfersController < BackofficeController

    def index
      @q = SimCard.ransack(params[:q])
      @sim_cards = @q.result
                     .includes(:user)
                     .by_support_point(current_user)
                     .transfered
                     .page(params[:page])
    end

  end
end
