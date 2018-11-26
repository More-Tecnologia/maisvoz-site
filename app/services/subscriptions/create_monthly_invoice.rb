module Subscriptions
  class CreateMonthlyInvoice

    def initialize(subscription)
      @subscription = subscription
    end

    def call
      return if generated_order? || subscription.expired? || subscription.canceled?

      subscription.with_lock do
        create_order
        update_subscription
      end
    end

    private

    attr_reader :subscription, :order

    delegate :user, to: :subscription

    def create_order
      @order = Order.new.tap do |order|
        order.status                   = Order.statuses[:pending_payment]
        order.type                     = Order.types[:monthly_fee]
        order.user                     = user
        order.club_motors_subscription = subscription
        order.total_cents              = price_cents + subscription.balance_cents
        order.subtotal_cents           = price_cents + subscription.balance_cents
        order.tax_cents                = 0
        order.shipping_cents           = 0

        order.save!
      end
    end

    def update_subscription
      subscription.status                 = ClubMotorsSubscription.statuses[:pending]
      subscription.balance_cents         += price_cents
      subscription.current_billing_cycle += 1
      subscription.next_billing_date      = next_billing_date

      subscription.save!
    end

    def generated_order?
      subscription.orders.where(
        created_at: this_month..this_month.end_of_month
      ).any?
    end

    def price_cents
      @price_cents ||= subscription.calculate_price_cents
    end

    def this_month
      @this_month ||= Date.new(Time.now.year, Time.now.month)
    end

    def next_billing_date
      @next_billing_date ||= Date.new(
        (subscription.next_billing_date + 1.month).year,
        (subscription.next_billing_date + 1.month).month,
        subscription.billing_day_of_month
      )
    end

  end
end
