module Backoffice
  class BonusContractsController < BackofficeController

    def index
      @q = BonusContract.ransack(query_params)
      @bonus_contracts = @q.result
                           .includes(:order)
                           .order(created_at: :desc)
                           .page(params[:page])
    end

    def show
      @bonus_contract = BonusContract.find_by_hashid(params[:id])
      @q = BonusContractItem.ransack(show_query_params)
      @bonus_contract_items = @q.result
                                .includes(financial_transaction: [:financial_reason])
                                .order(created_at: :desc)
                                .page(params[:page])
    end

    def query_params
      query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
      query.merge!(user_id_eq: current_user.id)
    end

    def show_query_params
      query = params[:q] ? params[:q].to_hash.symbolize_keys : {}
      query.merge!(bonus_contract_id_eq: @bonus_contract.id)
    end

  end
end
