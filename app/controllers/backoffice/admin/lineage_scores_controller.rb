module Backoffice
  module Admin
    class LineageScoresController < EntrepreneurController

      before_action :find_user, only: :index

      def index
        @q = Score.ransack(params[:q])
        @lineage_scores = @user ? Score.unilevel_scores_by_lineage(@user, @q) : []
      end

      private

      def find_user
        username = params[:q][:user_username_eq] if params[:q] && params[:q][:user_username_eq]
        @user = User.find_by(username: username) if username
      end

    end
  end
end
