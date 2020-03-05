module Backoffice
  module Admin
    class PoolLeadershipsController < FinancialController

      def new
        @pool_leadership = PoolLeadership.current_pool_leadership || PoolLeadership.new
      end

      def create
        @pool_leadership = PoolLeadership.create(valid_params)
        flash[:success] = t('.success') if @pool_leadership.save
        render :new
      end

      private

      def valid_params
        params.require(:pool_leadership)
              .permit(:amount)
      end

    end
  end
end
