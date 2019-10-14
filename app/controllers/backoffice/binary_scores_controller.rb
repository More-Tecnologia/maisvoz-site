module Backoffice
  class BinaryScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @scores = @q.result(distinct: true)
                  .binary_by_user(current_user)
                  .page(params[:page])
      @tree_type = 'binary'
      render template: 'backoffice/scores/index'
    end
  end
end
