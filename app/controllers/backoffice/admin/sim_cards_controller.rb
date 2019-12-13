module Backoffice
  module Admin
    class SimCardsController < AdminController

      before_action :find_order_item

      def new; end

      def create

      end

      private

      def find_order_item
        @order_item = OrderItem.find_by_hashid(params[:order_item_id])
      end

    end
  end
end
