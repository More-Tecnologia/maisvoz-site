module Backoffice
  class OrdersController < BackofficeController
    before_action :ensure_status, only: :index

    def index
      @orders = current_user.orders.__send__(params[:status].to_sym)
                                   .where.not(status: :cart)
                                   .order(created_at: :desc)
                                   .page(params[:page])
                                   .per(10)
    end

    def show
      @order = if current_user.admin?
                 Order.find(params[:id])
               else
                 current_user.orders.find_by_hashid(params[:id])
               end
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

    def ensure_status
      if params[:status].nil?
        params[:status] = 'all'
      end
    end

  end
end
