module Backoffice
  module ScoresHelper
    def find_score_types_by(tree_types)
      types = ScoreType.tree_types.slice(*tree_types).values
      ScoreType.by_tree_types(types).pluck(:name, :id)
    end

    def sum_cent_amount(scores)
      @cent_amount_sum ||= scores.sum { |e| e.cent_amount }
    end
  end
end
