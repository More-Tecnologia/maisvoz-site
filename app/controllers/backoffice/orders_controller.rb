module Backoffice
  class OrdersController < BackofficeController

    before_action :can_generate_boleto?, only: :generate_boleto

    def index
      @orders = current_user.orders.where.not(
        status: :cart
      ).order(created_at: :desc).includes(:payment_transaction)
    end

    def show
      @order = order
    end

    def generate_boleto
      order = current_user.orders.find_by_hashid(params[:order_id])
      if order.expire_at.blank?
        order.expire_at = 7.days.from_now
        order.save!
      end

      Payment::BradescoBoleto.new(order).call

      flash[:success] = 'Boleto adicionado a fila de processamento'
      redirect_to backoffice_orders_path
    end

    private

    def order
      @order ||= current_user.orders.find_by_hashid(params[:id])
    end

    def can_generate_boleto?
      flash[:error] = 'Emissão do boleto bancário não disponível.'
      redirect_to backoffice_orders_path
    end
  end
end
