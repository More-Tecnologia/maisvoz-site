module Backoffice
  class OrdersController < BackofficeController

    def index
      @orders = current_user.orders.includes(:payment_transaction)
                                   .where.not(status: :cart)
                                   .order(created_at: :desc)
    end

    def show
      @order = order
    end

    def generate_boleto
      order = current_user.orders.find_by_hashid(params[:order_id])
      if order.expire_at.blank?
        order.expire_at = 3.days.from_now
        order.save!
      end

      payment = Payment::BradescoBoleto.new(order).call
      if payment[:error].present?
        flash[:error] = payment[:error]
      else
        flash[:success] = 'Boleto adicionado a fila de processamento'
      end
      redirect_to backoffice_orders_path
    end

    private

    def order
      @order ||= current_user.orders.find_by_hashid(params[:id])
    end

  end
end
