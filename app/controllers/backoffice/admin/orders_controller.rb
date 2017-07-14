module Backoffice
  module Admin
    class OrdersController < AdminController

      def index
        @orders = Order.where.not(status: 0).order(created_at: :desc).page(params[:page])
      end

      def show
        @order = Order.find(params[:id])
      end

      def approve
        command = Financial::PaymentCompensation.call(order)

        if command.success?
          flash[:success] = 'sucess'
        else
          flash[:error] = 'error'
        end
        redirect_to backoffice_admin_orders_path
      end

      private

      def order
        @order ||= Order.find(params[:order_id])
      end

    end
  end
end
