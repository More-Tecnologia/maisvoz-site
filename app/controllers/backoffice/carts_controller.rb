module Backoffice
  class CartsController < BackofficeController
    def activate_free
      if free_product_already_purchased?
        @result = t('defaults.errors.duplicated_free_product')
      else
        add_cart = Shopping::AddToCart.call(current_order, 1, params[:country])
        if add_cart.success?
          current_order.update!(status: :pending_payment, payment_type: :free)
          current_order.create_payment_transaction!(amount: 0,
                                                    transaction_id: SecureRandom.hex,
                                                    wallet_address: SecureRandom.hex)
          command = Financial::PaymentCompensation.call(current_order)
          if command.success?
            clean_shopping_cart
            @result = 'success'
          end
        else
          @result = t(command.errors)
        end
      end
    end

    def show
      redirect_to backoffice_products_path unless current_order.order_items.any?

      @checkout_form = CheckoutForm.new(order: current_order, user: current_user)
    end

    def create
      if valid_params[:payment_method] == 'balance'
        @order = current_order
        Payment::BalanceService.call(order: @order)
        clean_shopping_cart
        redirect_to backoffice_order_path(@order)
      elsif valid_params[:payment_method] == 'pix'
        @payment_transaction = Payment::Pagstar::PixCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 1.hour, valid_params[:order].id)
        clean_shopping_cart
        render 'backoffice/payment_transactions/show'
      else
        @payment_transaction = Payment::BlockCheckoutService.call(valid_params)
        ExpireOrderWorker.perform_at(Time.now + 2.hours, valid_params[:order].id)
        clean_shopping_cart
        render 'backoffice/payment_transactions/show'
      end
    rescue StandardError => e
      flash[:error] = e.message
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
