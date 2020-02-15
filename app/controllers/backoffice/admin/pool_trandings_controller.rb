module Backoffice
  module Admin
    class PoolTrandingsController < FinancialController

      def new
        @pool_tranding = PoolTranding.current_pool_tranding || PoolTranding.new
      end

      def create
        @pool_tranding = PoolTranding.create(valid_params)
        flash[:success] = t('.success') if @pool_tranding.save
        render :new
      end

      private

      def valid_params
        params.require(:pool_tranding)
              .permit(:amount)
      end

    end
  end
end
