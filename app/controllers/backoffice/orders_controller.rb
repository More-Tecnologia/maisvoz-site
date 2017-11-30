module Backoffice
  class OrdersController < BackofficeController

    def index
      @orders = current_user.orders.where.not(status: :cart).order(created_at: :desc)
    end

    def show
      @order = current_user.orders.find(params[:id])
    end

  end
end
