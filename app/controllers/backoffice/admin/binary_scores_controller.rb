module Backoffice
  module Admin
    class BinaryScoresController < AdminController

      def index
        @q = Score.ransack(params[:q])
        @scores = @q.result(distinct: true)
                    .includes_associations
                    .binary
                    .order(created_at: :desc)
                    .page(params[:page])
      end

    end
  end
end
