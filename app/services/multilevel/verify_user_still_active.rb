module Multilevel
  class VerifyUserStillActive

    def initialize(user)
      @user = user
    end

    def call
      if active?
        user.active       = true
        user.active_until = 30.days.from_now.to_date
      else
        user.active = false
        user.active_until = 30.days.from_now.to_date
        # halve_pva_counters
      end
      verify_sponsor_qualification

      user.save!
    end

    private

    attr_reader :user

    def active?
      user.club_motors_subscriptions.active.any?
    end

    def verify_sponsor_qualification
      Multilevel::QualifyUser.new(user.sponsor).call
    end

    def halve_pva_counters
      user.sponsored.each do |u|
        u.update!(pva_total: u.pva_total / 2)
      end
    end

  end
end
