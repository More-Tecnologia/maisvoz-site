module Financial
  class UnlockBlockedBalance < ApplicationService

    def call
      transfer_blocked_balance if can_unlock_blocked_balance?
    end

    private

    attr_reader :user

    def initialize(args)
      @user = args[:user]
    end

    def transfer_blocked_balance
      user.with_lock do
        user.available_balance_cents = user.available_balance_cents + user.blocked_balance_cents
        user.blocked_balance_cents   = 0
        user.balance_unlocked_at     = Time.zone.now
        user.save!
      end
    end

    def can_unlock_blocked_balance?
      return false if user.current_career_trail.blank?

      threshold_balance_reached? || threshold_blocked_blance_reached? || minimum_period_reached?
    end

    def threshold_balance_reached?
      user.reached_career_trail_maximum_bonus?
    end

    def threshold_blocked_blance_reached?
      product_value = user.current_trail.product.product_value
      rate = user.balance_cents.to_f / product_value if product_value
      threshold_rate = user.current_career_trail.unlock_blocked_balance_threshold.to_f / 100.0
      rate.to_f > threshold_rate.to_f
    end

    def minimum_period_reached?
      threshold_time = user.current_career_trail.unlock_blocked_balance_min_period.days.ago
      threshold_time >= user.balance_unlocked_at if user.balance_unlocked_at
    end

  end
end
