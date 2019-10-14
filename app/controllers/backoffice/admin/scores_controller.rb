module Backoffice
  module Admin
    class ScoresController < AdminController
      def index
        @q = Score.ransack(params[:q])
        @scores = @q.result(distinct: true)
                    .includes_associations
                    .page(params[:page])
        render template: 'backoffice/scores/index'
      end
    end
  end
end
