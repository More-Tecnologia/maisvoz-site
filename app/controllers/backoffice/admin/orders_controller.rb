module Backoffice
  module Admin
    class OrdersController < AdminController

      def index
        @orders = Order.where.not(status: 0).order(created_at: :desc).page(params[:page])
      end

      def show
        @order = Order.find(params[:id])
      end

    end
  end
end
