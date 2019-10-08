module Backoffice
  class ScoresController < EntrepreneurController
    def index
      @q = Score.ransack(params[:q])
      @scores = @q.result(distinct: true)
                  .includes_associations
                  .page(params[:page])
    end
  end
end
