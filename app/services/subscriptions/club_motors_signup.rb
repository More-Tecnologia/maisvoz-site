module Subscriptions
  class ClubMotorsSignup

    def initialize(form:)
      @form = form
    end

    def call
      ActiveRecord::Base.transaction do
        setup_subscription
        create_cart
        add_to_cart
        checkout_cart
      end
    end

    private

    attr_reader :form, :cart, :subscription

    def setup_subscription
      @subscription = ClubMotorsSubscription.new.tap do |club_motors|
        club_motors.status               = ClubMotorsSubscription.statuses[:pending]
        club_motors.type                 = ClubMotorsSubscription.types[:clubmotors]
        club_motors.user                 = form.user
        club_motors.car_model            = form.car_model
        club_motors.plate                = form.plate

        club_motors.save!
      end
    end

    def create_cart
      @cart = Order.new.tap do |cart|
        cart.user                     = form.user
        cart.type                     = Order.types[:clubmotors_adhesion]
        cart.club_motors_subscription = subscription
      end
    end

    def add_to_cart
      Shopping::AddToCart.new(cart, form.club_motors.id).call
    end

    def checkout_cart
      Shopping::CheckoutCart.new(cart: cart).call
    end

    def today
      @today ||= Time.zone.now
    end

  end
end
