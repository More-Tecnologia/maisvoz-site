module Shopping
  class CheckoutCreatorService < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        create_address_for_order
        create_payment_transaction_for_order
      end
    end

    private

    def initialize(args)
      @checkout_form = args[:checkout_form]
      @order = @checkout_form.order
    end

    def create_address_for_order
      @order.create_address!(country: @checkout_form.shipping_address_country,
                             city: @checkout_form.shipping_address_city,
                             state: @checkout_form.shipping_address_state,
                             neighborhood: @checkout_form.shipping_address_neighborhood,
                             zipcode: @checkout_form.shipping_address_postal_code,
                             street: @checkout_form.shipping_address_street,
                             number: @checkout_form.shipping_address_number,
                             complement: @checkout_form.shipping_address_complement,
                             whatsapp: @checkout_form.whatsapp)
    end

    def create_payment_transaction_for_order
      Payment::BlockCheckoutService.call(order: @order)
    end
  end
end
