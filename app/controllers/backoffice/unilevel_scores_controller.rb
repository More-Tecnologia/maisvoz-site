module Backoffice
  class UnilevelScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @scores = @q.result(distinct: true)
                  .binary
                  .page(params[:page])
      @tree_type = 'unilevel'
      render template: 'backoffice/scores/index'
    end
  end
end
