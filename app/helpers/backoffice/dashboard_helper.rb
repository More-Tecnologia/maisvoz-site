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

    def qualification_score_sum
      current_user.lineage_scores
                  .sum(&:second).to_i
    end

    def withdrawal_status_text_class(withdrawal)
      text_class = { pending: 'text-info',
                     approved: 'text-success',
                     approved_balance: 'text-success',
                     refused: 'text-danger',
                     canceled: 'text-warning' }[withdrawal.status.to_s.to_sym]
      content_tag :span, t(withdrawal.status), class: text_class
    end
  end
end
