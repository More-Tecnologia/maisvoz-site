module Backoffice
  class CheckoutsController < BackofficeController

    def update
      if current_order.pending_payment!
        session.delete(:order_id)
        flash[:success] = I18n.t('defaults.order_placed')
      end
      redirect_to backoffice_orders_path
    end

  end
end
