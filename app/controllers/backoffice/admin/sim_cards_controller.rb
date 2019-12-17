module Backoffice
  module Admin
    class SimCardsController < AdminController

      before_action :find_order_item

      def new
        @sim_cards = @order_item.sim_cards
                                .includes(:user, :support_point_user)
                                .page(params[:page])
      end

      def create
        @order_item.create_sim_cards(valid_iccids)
        @sim_cards = @order_item.sim_cards
                                .page(params[:page])
        flash[:success] = t('defaults.sim_cards_created')
        render :new
      rescue StandardError => error
        flash[:error] = error.message
        redirect_to new_backoffice_admin_order_item_sim_card_path(@order_item)
      end

      def destroy
        @sim_card = SimCard.find_by_hashid(params[:id]).delete
        render js: "$('tr##{@sim_card.hashid}').remove();"
      end

      private

      def find_order_item
        @order_item = OrderItem.find_by_hashid(params[:order_item_id])
      end

      def valid_iccids
        params.require(:sim_cards)[:iccids].delete_if { |iccid| !iccid.present? }
      end

    end
  end
end
