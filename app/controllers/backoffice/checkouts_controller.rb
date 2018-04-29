module Backoffice
  class CheckoutsController < BackofficeController

    def update
      if current_order.cart? && current_order.total_cents > 0
        current_order.pending_payment!
        SlackMessageWorker.perform_async('#loja', "Pedido *#{current_order.hashid}* do usuário *#{current_order.user.username}* no valor de *R$ #{current_order.total}* realizado...")
        Payment::CreateTransaction.new(current_order).call
        ShoppingMailer.with(order: current_order).order_made.deliver_later
        session.delete(:order_id)
        flash[:success] = I18n.t('defaults.order_placed')
      end
      redirect_to backoffice_orders_path
    end

  end
end
