module Backoffice
  module Admin
    class SimCardReportsController < AdminController

      def index
        @q = SimCard.ransack(params[:q])
        @sim_cards = @q.result
                       .includes(:support_point_user, :user)
                       .page(params[:page])
      end

    end
  end
end
