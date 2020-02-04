module Backoffice
  class PaymentBlockCheckoutsController < BackofficeController

    def new
        raise Exception unless current_order.persisted?
        @payment_transaction = Payment::BlockCheckoutService.call(order: current_order)
        clean_shopping_cart
        render 'backoffice/payment_transactions/show'
      rescue Exception => error
        flash[:error] = error.message
        redirect_to backoffice_cart_path
    end

  end
end
