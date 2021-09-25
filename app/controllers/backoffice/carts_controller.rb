module Backoffice
  class CartsController < BackofficeController

    def show
      @checkout_form = CheckoutForm.new(order: current_order, user: current_user)
    end

    def create
      if current_order.products.first == Product.first
        current_order.update!(status: :pending_payment, payment_type: :free)
        current_order.create_payment_transaction!(amount: 0,
                                                  transaction_id: SecureRandom.hex,
                                                  wallet_address: SecureRandom.hex)
        command = Financial::PaymentCompensation.call(current_order)
        if command.success?
          clean_shopping_cart
          flash[:success] = I18n.t('defaults.free_product')
          redirect_to backoffice_dashboard_index_path
        else
          redirect_back(fallback_location: backoffice_products_path)
        end
      else
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        clean_shopping_cart
        render 'backoffice/payment_transactions/show'
      end
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
