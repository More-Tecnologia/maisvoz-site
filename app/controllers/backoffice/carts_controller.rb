module Backoffice
  class CartsController < BackofficeController
    def show
      @checkout_form = CheckoutForm.new(order: current_order, user: current_user)
    end

    def create
      @checkout_form = CheckoutForm.new(valid_params)
      raise @checkout_form.errors.full_messages.join(', ') if @checkout_form.invalid?
      @payment_transaction =
        Shopping::CheckoutCreatorService.call(checkout_form: @checkout_form)
      clean_shopping_cart
      render 'backoffice/payment_transactions/show'
    rescue StandardError => error
      flash[:error] = error.message
      render :show
    end

    private

    def valid_params
      params.permit(:order, :shipping_address, :custom_shipping_address_postal_code,
                    :custom_shipping_address_complement, :custom_shipping_address_number,
                    :custom_shipping_address_neighborhood, :custom_shipping_address_street,
                    :custom_shipping_address_city, :custom_shipping_address_state,
                    :backoffice_shipping_address_postal_code, :backoffice_shipping_address_complement,
                    :backoffice_shipping_address_number, :backoffice_shipping_address_neighborhood,
                    :backoffice_shipping_address_street, :backoffice_shipping_address_city,
                    :backoffice_shipping_address_state, :custom_shipping_address_country,
                    :backoffice_shipping_address_country, :whatsapp)
            .merge(order: current_order, user: current_user)
    end
  end
end
