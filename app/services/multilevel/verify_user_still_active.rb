module Multilevel
  class VerifyUserStillActive

    def initialize(user, date)
      @user = user
      @date = Date.parse(date)
    end

    def call
      if still_active?
        user.active = true
        user.active_until = 30.days.from_now.to_date
      else
        user.active = false
      end
      verify_sponsor_qualification
      halve_pva_counters

      user.save!
    end

    private

    attr_reader :user, :date

    def still_active?
      user.orders.monthly_fees.completed.where(
        'created_at >= ? AND created_at <= ?', beginning_of_activity, user.active_until
      ).any?
    end

    def verify_sponsor_qualification
      Multilevel::QualifyUser.new(user.sponsor).call
    end

    def halve_pva_counters
      user.sponsored.each do |u|
        u.update!(pva_total: u.pva_total / 2)
      end
    end

    def beginning_of_activity
      user.active_until - 30.days
    end

  end
end
