module Backoffice
  class ScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @scores = @q.result(distinct: true)
                  .by_tree_types(valid_tree_types)
                  .page(params[:page])
    end

    private

    def valid_tree_types
      ScoreType.tree_types.slice(*params[:tree_types]).values
    end
  end
end
