module Backoffice
  module Admin
    class ClubMotorsSubscriptionsController < SupportController

      def index
        @grid = ClubMotorsSubscriptionsGrid.new(grid_params) do |scope|
          scope.page(params[:page])
        end
      end

      def show
        @subscription = ClubMotorsSubscription.find(params[:id])
      end

      protected

      def grid_params
        params.fetch(:club_motors_subscriptions_grid, {}).permit!
      end

    end
  end
end