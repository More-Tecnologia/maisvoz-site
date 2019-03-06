module Subscriptions
  class ActivateClubMotors

    def initialize(subscription:)
      @subscription = subscription
    end

    def call
      ActiveRecord::Base.transaction do
        update_subscription
        update_subscription_dates
        create_invoice
      end
    end

    private

    attr_reader :subscription

    def update_subscription
      subscription.status               = status
      subscription.type                 = ClubMotorsSubscription.types[:clubmotors]
      subscription.price_cents          = subscription.calculate_price_cents
      subscription.billing_day_of_month = billing_date.day

      subscription.save!
    end

    def update_subscription_dates
      if subscription.active?
        subscription.activated_at         = now
        subscription.current_period_start = now
        subscription.current_period_end   = billing_date
        subscription.next_billing_date    = billing_date
      else
        subscription.next_billing_date = billing_date
      end

      subscription.save!
    end

    def create_invoice
      return if subscription.active?

      Subscriptions::CreateMonthlyInvoice.new(subscription).call
    end

    def status
      @status ||= ClubMotorsSubscription.statuses[:inactive]
    end

    def now
      @now ||= Time.zone.now
    end

    def billing_date
      if subscription.active?
        @billing_date ||= CalculateBillingDate.new(
          subscription.user.active_until
        ).call
      else
        @billing_date ||= CalculateBillingDate.new.call
      end
    end

  end
end
