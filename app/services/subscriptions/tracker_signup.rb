module Subscriptions
  class TrackerSignup

    def initialize(form:)
      @form = form
    end

    def call
      ActiveRecord::Base.transaction do
        setup_subscription
        update_subscription
        create_cart
        add_to_cart
        update_cart
        checkout_cart
      end
    end

    private

    attr_reader :form, :cart, :subscription

    def setup_subscription
      @subscription = ClubMotorsSubscription.new.tap do |club_motors|
        club_motors.status    = ClubMotorsSubscription.statuses[:inactive]
        club_motors.type      = ClubMotorsSubscription.types[:tracker]
        club_motors.user      = form.user
        club_motors.car_model = form.car_model
        club_motors.plate     = form.plate

        club_motors.save!
      end
    end

    def update_subscription
      subscription.billing_day_of_month   = billing_date.day
      subscription.next_billing_date      = billing_date + 1.month
      subscription.balance_cents         += form.tracker_price_cents
      subscription.current_billing_cycle += 1

      subscription.save!
    end

    def create_cart
      @cart = Order.new.tap do |cart|
        cart.user    = form.user
        cart.type    = Order.types['monthly_fee']
        cart.payable = subscription
        cart.expire_at = 10.days.from_now
      end
    end

    def add_to_cart
      Shopping::AddToCart.new(cart, form.tracker.id).call
    end

    def update_cart
      cart.update!(total_cents: form.tracker_price_cents, subtotal_cents: form.tracker_price_cents)
      cart.order_items.first.update!(total_cents: form.tracker_price_cents, unit_price_cents: form.tracker_price_cents)
    end

    def checkout_cart
      Shopping::CheckoutCart.new(cart: cart).call
    end

    def billing_date
      @billing_date ||= CalculateBillingDate.new.call
    end

  end
end
