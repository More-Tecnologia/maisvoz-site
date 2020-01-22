module Backoffice
  class LineageScoresController < EntrepreneurController

    def index
      @q = Score.ransack(params[:q])
      @lineage_scores = Score.unilevel_scores_by_lineage(current_user, @q)
    end

  end
end
