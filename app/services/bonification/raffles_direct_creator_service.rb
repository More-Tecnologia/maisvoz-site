# frozen_string_literal: true

module Bonification
  class RafflesDirectCreatorService < ApplicationService
    DIRECT_BONUS_REASON = FinancialReason.raffles_direct_commission_bonus

    PERCENTAGES = { 
      '1': { commission: 0.20, reason: DIRECT_BONUS_REASON } 
    }.freeze

    def call
      sponsors.each_with_index do |sponsor, index|
        next if sponsor.admin?

        transaction = create_bonus_for(sponsor, index + 1)
        # if sponsor.inactive?
        #   chargeback_reason = transaction.financial_reason.chargeback_by_inactivity
        #   transaction.chargeback_by_inactivity!(chargeback_reason)
        # end
      end
    end

    def initialize(params)
      @raffle_ticket = params[:raffle_ticket]
      @user = @raffle_ticket.user
      @amount = @raffle_ticket.order_item.total_cents
    end

    private

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors
                            .bonus_receivers(PERCENTAGES.size)

      unilevel_nodes.is_a?(Array) ? unilevel_nodes.reverse.map(&:user) : [unilevel_nodes.user]
    end

    def create_bonus_for(sponsor, generation)
      data = PERCENTAGES[generation.to_s.to_sym]
      cent_amount = (data[:commission] * @amount) / 100

      sponsor.financial_transactions
             .create!(spreader: @user,
                     financial_reason: data[:reason],
                     moneyflow: :credit,
                     cent_amount: cent_amount) if cent_amount.positive?
    end
  end
end
