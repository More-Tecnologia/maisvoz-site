module Backoffice
  module Admin
    class ScoresController < AdminController
      def index
        @tree_type = 'unilevel'
        @q = Score.ransack(params[:q])
        @scores = @q.result(distinct: true)
                    .includes_associations
                    .order(created_at: :desc)
                    .page(params[:page])
        render template: 'backoffice/scores/index'
      end
    end
  end
end
