module Subscriptions
  class ClubMotorsSignup

    def initialize(form:, cart:)
      @form = form
      @cart = cart
    end

    def call
      add_to_cart
      setup_subscription
      checkout_cart
    end

    private

    attr_reader :form, :cart

    def add_to_cart
      Shopping::AddToCart.new(cart, form.club_motors.id).call
    end

    def setup_subscription
      club_motors_subscription = ClubMotorsSubscription.new.tap do |club_motors|
        club_motors.user      = form.user
        club_motors.car_model = form.car_model
        club_motors.plate     = form.plate
        club_motors.save!
      end


      Subscription.new.tap do |subscription|
        subscription.user             = form.user
        subscription.status           = Subscription.statuses[:provide_info]
        subscription.subscriptionable = club_motors_subscription

        subscription.save!
      end
    end

    def checkout_cart
      Shopping::CheckoutCart.new(cart: cart).call
    end

  end
end
