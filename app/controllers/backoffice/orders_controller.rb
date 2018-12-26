module Backoffice
  class OrdersController < BackofficeController

    def index
      @orders = current_user.orders.where.not(
        status: :cart
      ).order(created_at: :desc).includes(:payment_transactions)
    end

    def show
      @order = order
    end

    def generate_boleto
      order = current_user.orders.find_by_hashid(params[:order_id])
      BradescoBoletoGeneratorWorker.perform_async(order.id)
      flash[:success] = 'Boleto adicionado a fila de processamento'
      redirect_to backoffice_orders_path
    end

    private

    def order
      @order ||= current_user.orders.find_by_hashid(params[:id])
    end

  end
end
