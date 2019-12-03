module Backoffice
  module Admin
    class UnilevelScoresController < AdminController

      def index
        @q = Score.ransack(query_params)
        @scores = @q.result
                    .includes_associations
                    .order(created_at: :desc)
                    .page(params[:page])
      end

      def query_params
        query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
        query.merge!(score_type_id_in: ScoreType.unilevel.pluck(:id)) unless filled?(query[:score_type_id_in])
        query
      end

    end
  end
end
