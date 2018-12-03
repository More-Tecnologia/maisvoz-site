module Subscriptions
  class CreateUpgrade

    def initialize(form:)
      @form = form
    end

    def call
      ActiveRecord::Base.transaction do
        create_cart
        add_to_cart
        checkout_cart
      end
    end

    private

    attr_reader :form, :cart

    def create_cart
      @cart = Order.new.tap do |cart|
        cart.user = form.user
        cart.type = Order.types[:upgrade]
      end
    end

    def add_to_cart
      Shopping::AddToCart.new(cart, form.subscription.id).call
    end

    def checkout_cart
      cart.total_cents    = form.total_cents
      cart.subtotal_cents = form.total_cents
      cart.pv_total       = form.pv_total
      cart.status         = Order.statuses[:pending_payment]

      cart.save!
    end

  end
end
