module Backoffice
  module Admin
    class CareerHistoriesController < BackofficeController

      def index
        authorize :admin_career_histories, :index?

        @grid = CareerHistoriesGrid.new(grid_params)

        @grid.scope {|scope| scope.page(params[:page]) }
      end

      private

      def grid_params
        params.fetch(:career_histories_grid, {}).permit!
      end

    end
  end
end
