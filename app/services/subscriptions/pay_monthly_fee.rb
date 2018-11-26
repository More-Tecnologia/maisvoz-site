module Subscriptions
  class PayMonthlyFee

    def initialize(order:)
      @order = order
      @user = order.user
    end

    def call
      decrease_balance
      update_subscription
      update_user
    end

    private

    attr_reader :order, :user

    def decrease_balance
      subscription.balance_cents -= order.total_cents
    end

    def update_subscription
      return unless subscription.balance_cents.zero?

      subscription.active!
      subscription.current_period_start = now
      subscription.current_period_end   = current_period_end - 1.day

      subscription.save!
    end

    def update_user
      user.active       = true
      user.active_until = current_period_end if user.active_until < current_period_end

      user.save!
    end

    def current_period_end
      @current_period_end ||= Date.new(
        (now + 1.month).year,
        (now + 1.month).month,
        subscription.billing_day_of_month
      )
    end

    def now
      @now ||= Time.zone.now
    end

    def subscription
      @subscription ||= order.club_motors_subscription
    end

  end
end
