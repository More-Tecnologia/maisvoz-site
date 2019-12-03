module Backoffice
  module CareersHelper

    def careers_for_select
      @careers_for_select ||= Career.order(:qualifying_score).pluck(:name, :id)
    end

    def find_binary_qualifying_career(career_id)
      return unless career_id
      careers_for_select.detect { |c| c.second.to_i == career_id.to_i }
    end

  end
end
