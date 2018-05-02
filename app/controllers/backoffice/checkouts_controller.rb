module Backoffice
  class CheckoutsController < BackofficeController

    def update
      if current_order.cart? && current_order.total_cents > 0
        current_order.pending_payment!
        BradescoBoletoGeneratorWorker.perform_async(current_order.id)
        SlackMessageWorker.perform_async('#loja', "Pedido *#{current_order.hashid}* do usuário *#{current_order.user.username}* no valor de *R$ #{current_order.total}* realizado...")
        session.delete(:order_id)
        flash[:success] = I18n.t('defaults.order_placed')
      end
      redirect_to backoffice_orders_path
    end

  end
end
