module Backoffice
  class CartsController < BackofficeController
    before_action :ensure_payment_method, only: :create

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

    def ensure_payment_method
      raise I18n.t(:no_payment_method_selected) unless params['payment_method'].in?(%w[pix bitcoin])
    rescue StandardError => e
      flash[:error] = e.message
      render :show
    end

    def valid_params
      params.permit(:payment_method)
            .merge(order: current_order)
    end
  end
end
