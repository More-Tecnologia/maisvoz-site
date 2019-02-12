module Subscriptions
  class ClubMotorsSignup

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

    attr_reader :form, :cart, :subscription

    def create_cart
      @cart = Order.new.tap do |cart|
        cart.user      = form.user
        cart.type      = Order.types[:clubmotors_adhesion]
        cart.payable   = subscription
        cart.expire_at = 10.days.from_now
      end
    end

    def add_to_cart
      Shopping::AddToCart.new(cart, form.club_motors.id).call
    end

    def checkout_cart
      Shopping::CheckoutCart.new(cart: cart).call
    end

  end
end
