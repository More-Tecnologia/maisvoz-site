module Backoffice
  class UnilevelScoresController < EntrepreneurController

    def index
      @q = Score.ransack(query_params)
      @scores = @q.result
                  .includes(:spreader_user, :order, :score_type)
                  .order(created_at: :desc)
                  .page(params[:page])
    end

    def query_params
      query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
      query.merge!(score_type_id_in: ScoreType.unilevel.pluck(:id)) unless filled?(query[:score_type_id_in])
      query.merge!(user_id_eq: current_user.id)
    end

  end
end
