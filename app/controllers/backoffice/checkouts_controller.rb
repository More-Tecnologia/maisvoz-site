module Backoffice
  class CheckoutsController < BackofficeController

    def update
      if Shopping::CheckoutCart.new(cart: current_order).call
        session.delete(:order_id)
        flash[:success] = I18n.t('defaults.order_placed')
      end
      redirect_to backoffice_orders_path
    end

    def checkout_blocked
      flash[:error] = 'As compras serão liberadas em breve.'
      redirect_back fallback_location: root_path
    end

  end
end
