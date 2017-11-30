module Multilevel
  class VerifyNodeStillActive

    MINIMUM_PV_ACTIVITY = 500.0

    def initialize(node, date)
      @node = node
      @date = Date.parse(date)
    end

    def call
      if pv_activities_sum >= MINIMUM_PV_ACTIVITY
        node.active = true
        node.active_until = 6.months.from_now
      else
        node.active = false
      end
      verify_sponsor_qualification
      node.save!
    end

    private

    attr_reader :node, :date

    def pv_activities_sum
      @pv_activities_sum ||= PvActivitySemesterHistoryQuery.new(user, date).call / 100.0
    end

    def verify_sponsor_qualification
      Multilevel::QualifyUser.new(node.sponsor).call
    end

    def user
      @user ||= node.user
    end

  end
end
