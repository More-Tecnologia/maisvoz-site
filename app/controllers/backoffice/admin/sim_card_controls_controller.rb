module Backoffice
  module Admin
    class SimCardControlsController < AdminController

      def new
        @q = OrderItem.search(params[:q])
        @sim_card_order_items = @q.result.includes(:product, :sim_cards, order: [:user])
                                         .sim_card
                                         .paid
                                         .order(processed_at: :desc)
                                         .page(params[:page])
      end

    end
  end
end
