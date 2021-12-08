module Bonification
  class GenericBonusCreatorService < ApplicationService

    def call
      create_financial_transactions
      @transactions
    end

    def initialize(params)
      @reason = params[:reason]
      @amount = params[:amount]
      @spreader = params[:spreader]
      @sponsor = params[:sponsor]
      @order = params[:order]
      @generation = params[:generation]
      @chargebackable = params[:chargebackable].presence || false
      @transactions = []
    end

    private

    def create_financial_transactions
      while @amount > 0
        contract = @sponsor.bonus_contracts
                           .active
                           .reject(&:max_gains?)
                           .sort_by(&:created_at)
                           .first
        if contract.present?
          to_receive = (contract.max_task_gains - contract.task_gains).round
          to_receive = to_receive > 0 ? to_receive : 0
          if to_receive > @amount
            value = @amount
            @amount -= @amount
          else
            value = to_receive
            @amount -= to_receive
          end
        else
          chargebackable = @chargebackable
          contract = @sponsor.bonus_contracts.last
          value = @amount
          @amount -= @amount
        end
        transaction = @sponsor.financial_transactions
                              .create!(spreader: @spreader,
                                       financial_reason: @reason,
                                       generation: @generation,
                                       cent_amount: value,
                                       bonus_contract: contract,
                                       order: @order)
        if chargebackable
          transaction.chargeback_by_inactivity!(FinancialReason.chargeback_by_max_gains)
        else
          @transactions << transaction
        end
      end
    end
  end
end
