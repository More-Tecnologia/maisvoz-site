module Backoffice
  class CheckoutsController < BackofficeController

    def update
      current_order.pending_payment!
      session[:order_id] = nil
      flash[:success] = I18n.t('defaults.order_placed')
      redirect_to backoffice_products_path
    end

  end
end
