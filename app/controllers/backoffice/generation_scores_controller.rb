module Backoffice
  class GenerationScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @generation_scores = @q.result(distinct: true)
                             .where(user: current_user)
                             .sum_by_generation
    end
  end
end
