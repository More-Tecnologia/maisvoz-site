module Subscriptions
  class ActivateClubMotors

    def initialize(user)
      @user = user
    end

    def call
      subscription.status = ClubMotorsSubscription.statuses[:active]
      subscription.type = ClubMotorsSubscription.types[:clubmotors]
      subscription.current_period_start = now
      subscription.current_period_end = now + 30.days
      subscription.activated_at = now

      subscription.save!
    end

    private

    attr_reader :user

    def subscription
      @subscription ||= user.club_motors_subscriptions.last
    end

    def now
      @now ||= Time.zone.now
    end

  end
end