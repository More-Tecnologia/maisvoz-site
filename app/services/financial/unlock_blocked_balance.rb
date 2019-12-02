module Financial
  class UnlockBlockedBalance < ApplicationService
    def call
      return unless unlock_blocked_balance?

      transfer_blocked_balance
    end

    private

    attr_reader :user

    def initialize(args)
      @user = args[:user]
    end

    def transfer_blocked_balance
      user.with_lock do
        user.balance_cents         = user.blocked_balance_cents
        user.blocked_balance_cents = 0
        user.balance_unlocked_at   = Time.zone.now
        user.save!
      end
    end

    def unlock_blocked_balance?
      return false if user.current_career_trail.blank?

      threshold_reached? || minimum_period_reached?
    end

    def threshold_reached?
      user.blocked_balance_cents / user.current_trail.product.price_cents * 1e2 >=
        user.current_career_trail.unlock_blocked_balance_threshold
    end

    def minimum_period_reached?
      user.current_career_trail.unlock_blocked_balance_min_period.days.ago >=
        user.balance_unlocked_at
    end

  end
end
