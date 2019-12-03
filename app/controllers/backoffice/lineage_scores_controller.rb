module Backoffice
  class LineageScoresController < EntrepreneurController

    def index
      @q = Score.ransack(params[:q])
      children_ids = current_user.unilevel_node
                                 .children
                                 .pluck(:user_id)
      received_scores = @q.result
                          .sum_unilevel_received_by(children_ids)
      spreaded_scores_from_children = @q.result
                                        .where(user: current_user)
                                        .sum_unilevel_spreaded_by(children_ids)
      @lineage_scores =
        sum_by_user(received_scores, spreaded_scores_from_children).to_a
                                                                   .sort_by(&:second)
                                                                   .reverse
    end

    private

    def sum_by_user(received_scores, spreaded_scores)
      received_scores.merge(spreaded_scores) { |key, old, new| old + new }
    end

  end
end
