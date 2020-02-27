module Backoffice
  module DashboardHelper

    def last_qualifications
      @last_qualifications ||= CareerTrailUser.includes(:user, career_trail: [:career])
                                              .joins(career_trail: [:career])
                                              .where.not(career_trail: CareerTrail.first)
                                              .last(10)
                                              .uniq { |u| u.career_trail_id && u.user_id }
    end

    def last_withdrawals
      @last_withdrawals ||= current_user.withdrawals
                                        .last(10)
                                        .reverse
    end

  end
end
