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
        order.status         = Order.statuses[:pending_payment]
        order.type           = Order.types[:monthly_fee]
        order.user           = user
        order.payable        = subscription
        order.total_cents    = price_cents
        order.subtotal_cents = price_cents
        order.expire_at      = expire_at
        order.tax_cents      = 0
        order.shipping_cents = 0

        order.save!
      end
    end

    def update_subscription
      subscription.next_billing_date      = next_billing_date
      subscription.balance_cents         += price_cents
      subscription.current_billing_cycle += 1

      subscription.save!
    end

    def generated_order?
      subscription.orders.monthly_fees.where(
        created_at: this_month..this_month.end_of_month
      ).where(payable: subscription).any?
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

    def expire_at
      subscription.current_period_end || subscription.next_billing_date
    end

  end
end
