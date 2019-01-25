module Subscriptions
  class CheckStatus

    def call
      ClubMotorsSubscription.active.where(
        'current_period_end <= ?', 7.days.ago.to_date
      ).find_each do |subscription|
        subscription.past_due!
      end
    end

  end
end
