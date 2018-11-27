module Subscriptions
  class ActivateClubMotors

    def initialize(subscription:)
      @subscription = subscription
    end

    def call
      ActiveRecord::Base.transaction do
        update_subscription
        create_invoice
      end
    end

    private

    attr_reader :subscription

    def update_subscription
      subscription.status               = status
      subscription.current_period_start = now
      subscription.current_period_end   = current_period_end - 1.day
      subscription.price_cents          = price_cents
      subscription.next_billing_date    = current_period_end
      subscription.billing_day_of_month = billing_day_of_month

      subscription.save!
    end

    def create_invoice
      Subscriptions::CreateMonthlyInvoice.new(subscription).call
    end

    def status
      if subscription.user.club_motors_subscriptions.where(status: :active).any?
        ClubMotorsSubscription.statuses[:inactive]
      else
        ClubMotorsSubscription.statuses[:active]
      end
    end

    def current_period_end
      @current_period_end ||= Date.new((now + 1.month).year, (now + 1.month).month, billing_day_of_month)
    end

    def price_cents
      @price_cents ||= subscription.calculate_price_cents
    end

    def billing_day_of_month
      [now.day, 28].min
    end

    def now
      @now ||= Time.zone.now
    end

    def product
      subscription.user.product
    end

  end
end
