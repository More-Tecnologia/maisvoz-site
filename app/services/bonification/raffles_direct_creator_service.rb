# frozen_string_literal: true

module Bonification
  class RafflesDirectCreatorService < ApplicationService
    DIRECT_BONUS_REASON = FinancialReason.raffles_direct_commission_bonus

    def call
      create_bonus if cent_amount.positive?
    end

    def initialize(params)
      @raffle_ticket = params[:raffle_ticket]
      @user = @raffle_ticket.user
      @amount = @raffle_ticket.order_item.total_cents
    end

    private

    def cent_amount
      @cent_amount ||= (SystemConfiguration.raffles_direct_commission_bonus * @amount) / 100
    end

    def create_bonus
      @user.sponsor
           .financial_transactions
           .create!(spreader: @user,
                    financial_reason: DIRECT_BONUS_REASON,
                    moneyflow: :credit,
                    cent_amount: cent_amount) 
    end
  end
end
