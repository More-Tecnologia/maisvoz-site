module Backoffice
  class UnilevelScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @scores = @q.result(distinct: true)
                  .unilevel_by_user(current_user)
                  .page(params[:page])
      @tree_type = 'unilevel'
      render template: 'backoffice/scores/index'
    end
  end
end
