module Multilevel
  class VerifyNodeStillActive

    MINIMUM_PV_ACTIVITY = 500.0

    def initialize(node, date)
      @node = node
      @date = date
    end

    def call
      if pv_activities_sum >= MINIMUM_PV_ACTIVITY
        node.active = true
        node.active_until = node.active_until + 6.months
      else
        node.active = false
      end
      node.save!
    end

    private

    attr_reader :node, :date

    def pv_activities_sum
      @pv_activities_sum ||= pv_activities.sum(&:amount).to_f
    end

    def pv_activities
      @pv_activities ||= PvActivitySemesterHistoryQuery.new(user, date).call
    end

    def user
      @user ||= node.user
    end

  end
end
