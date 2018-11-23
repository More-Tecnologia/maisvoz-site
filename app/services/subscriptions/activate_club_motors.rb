module Subscriptions
  class ActivateClubMotors

    def initialize(order)
      @order = order
    end

    def call
      subscription.status               = ClubMotorsSubscription.statuses[:active]
      subscription.current_period_start = now
      subscription.current_period_end   = current_period_end
      subscription.activated_at         = now if subscription.activated_at.blank?

      subscription.save!
    end

    private

    attr_reader :order

    def subscription
      @subscription ||= order.club_motors_subscription
    end

    def current_period_end
      Date.new((now + 1.month).year, (now + 1.month).month, subscription.billing_day_of_month)
    end

    def now
      @now ||= Time.zone.now
    end

  end
end
