module Backoffice
  class BinaryScoresController < EntrepreneurController

    def index
      @q = Score.ransack(query_params)
      @scores = @q.result
                  .includes(:spreader_user, :score_type, :order)
                  .order(created_at: :desc)
                  .page(params[:page])
    end

    private

    def query_params
      query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
      query.merge!(source_leg_eq: Score.source_legs[:left]) unless filled?(query[:source_leg_eq])
      query.merge!(score_type_id_in: ScoreType.binary.pluck(:id)) unless filled?(query[:score_type_id_in])
      query.merge!(user_id_eq: current_user.id)
    end

  end
end
