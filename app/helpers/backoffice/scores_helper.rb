module Backoffice
  module ScoresHelper

    def translate_source_leg(source_leg)
      I18n.t("attributes.#{source_leg}")
    end

    def sum_cent_amount(scores)
      @cent_amount_sum ||= scores.map(&:cent_amount).sum
    end

    def sum_score_cent_amount(q, scores)
      first_score_id = scores.try(:first).try(:id)
      return 0 unless first_score_id
      q.result
       .where('scores.id <= ?', first_score_id)
       .order(created_at: :desc)
       .sum(:cent_amount)
    end

    def score_status(score)
      return content_tag(:span, t('defaults.score_active'), class: 'label label-success') if score.active?
      content_tag(:span, t('defaults.score_expired'), class: 'label label-danger')
    end

  end
end
