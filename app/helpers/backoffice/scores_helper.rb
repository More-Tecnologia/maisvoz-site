module Backoffice
  module ScoresHelper

    def translate_source_leg(source_leg)
      I18n.t("attributes.#{source_leg}")
    end

    def sum_cent_amount(scores)
      @cent_amount_sum ||= scores.map(&:cent_amount).sum
    end
    
  end
end
