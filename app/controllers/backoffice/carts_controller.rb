module Backoffice
  class CartsController < BackofficeController
    def show
      redirect_to backoffice_products_path unless current_order.order_items.any?

      @checkout_form = CheckoutForm.new(order: current_order, user: current_user)
    end

    def create
      if current_order.products.first == Product.first
        if free_product_already_purchased?
          flash[:alert] = t('defaults.errors.duplicated_free_product')
          redirect_back(fallback_location: backoffice_dashboard_index_path) and return
        end
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
        ExpireOrderWorker.perform_at(Time.now + 5.hour, valid_params[:order].id)
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

    def free_product_already_purchased?
       OrderItem.includes(:product, :order)
                .where(order: Order.paid, 'orders.user': current_user)
                .where(product: Product.first)
                .any?
    end
  end
end
