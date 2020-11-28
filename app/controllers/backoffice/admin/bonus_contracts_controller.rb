module Backoffice
  module Admin
    class BonusContractsController < BackofficeController
      def index
        respond_to do |format|
          format.html { @bonus_contracts = bonus_contracts.page(params[:page]) }
          format.csv {  }
        end
      end

      def bonus_contracts
        @q = BonusContract.ransack(params[:q])
        query = @q.result
                  .includes(:order, :user)
                  .order(created_at: :desc)
        query.merge!(BonusContract.active) if params['active'] == 'true'
        query.merge!(BonusContract.inactive) if params['active'] == 'false'
        query
      end
    end
  end
end
