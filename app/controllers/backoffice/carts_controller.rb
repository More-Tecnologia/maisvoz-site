module Backoffice
  class CartsController < BackofficeController
    def show
      @checkout_form = CheckoutForm.new(order: current_order, user: current_user)
    end

    def create
      @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
      clean_shopping_cart
      render 'backoffice/payment_transactions/show'
    rescue StandardError => error
      flash[:error] = error.message
      render :show
    end

    private

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_order)
    end
  end
end
