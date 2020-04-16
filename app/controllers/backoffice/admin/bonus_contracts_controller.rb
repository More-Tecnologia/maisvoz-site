module Backoffice
  module Admin
    class BonusContractsController < BackofficeController

      def index
        @q = BonusContract.ransack(query_params)
        @bonus_contracts = @q.result
                             .includes(:order)
                             .order(created_at: :desc)
                             .page(params[:page])
      end

      def query_params
        query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
      end

    end
  end
end
