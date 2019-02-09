module Subscriptions
  class PayMonthlyFee

    def initialize(order:)
      @order = order
      @user = order.user
    end

    def call
      return if order.payable.blank?

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
      subscription.activated_at         ||= now
      subscription.current_period_start = now
      subscription.current_period_end   = current_period_end

      subscription.save!
    end

    def update_user
      return if user.active_until.blank?

      user.active       = true
      user.active_until = activation_period if user.active_until < activation_period

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

    def activation_period
      @activation_period ||= now + 30.days
    end

    def subscription
      @subscription ||= order.payable
    end

  end
end
