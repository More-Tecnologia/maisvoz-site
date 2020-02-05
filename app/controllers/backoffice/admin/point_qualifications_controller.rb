module Backoffice
  module Admin
    class PointQualificationsController < AdminController

      def index
        @q = Score.ransack(query_params)
        @scores = @q.result
                    .includes(:spreader_user, :order)
                    .order(created_at: :desc)
                    .page(params[:page])
      end

      private

      def query_params
        query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
        query.merge!(source_leg_eq: Score.source_legs[:left]) unless filled?(query[:source_leg_eq])
        query.merge!(score_type_id_in: ScoreType.binary_score.id) unless filled?(query[:score_type_id_in])
      end

    end
  end
end
