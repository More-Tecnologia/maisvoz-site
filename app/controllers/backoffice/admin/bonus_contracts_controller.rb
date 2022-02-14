module Backoffice
  module Admin
    class BonusContractsController < BackofficeController
      include Backoffice::BonusContractsCsvHelper

      def index
        respond_to do |format|
          format.html { @bonus_contracts = bonus_contracts.page(params[:page]) }
          format.csv { render_bonus_contracts_as_csv(bonus_contracts) }
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

      def toggle_enabled_bonification
        bonus_contract = BonusContract.find_by_hashid(params[:id])
        bonus_contract.toggle!(:enabled_bonification)

        redirect_to backoffice_admin_bonus_contracts_path
      end
    end
  end
end
