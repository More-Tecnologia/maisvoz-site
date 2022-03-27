# frozen_string_literal: true

module Bonification
  class AdsDirectIndirectCreatorService < ApplicationService
    PERCENTAGES = {
                    '1': { commission: 0.15, reason: FinancialReason.ads_direct_commission_bonus },
                    '2': { commission: 0.05, reason: FinancialReason.ads_indirect_commission_bonus },
                    '3': { commission: 0.03, reason: FinancialReason.ads_indirect_commission_bonus },
                    '4': { commission: 0.02, reason: FinancialReason.ads_indirect_commission_bonus },
                    '5': { commission: 0.01, reason: FinancialReason.ads_indirect_commission_bonus }
                  }.freeze

    def initialize(params)
      @ad = params[:ad]
      @user = @ad.user
      @amount = params[:amount]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        sponsors.each_with_index do |sponsor, index|
          next if sponsor.admin?

          transaction = create_bonus_for(sponsor, index + 1)
          if sponsor.inactive?
            chargeback_reason = transaction.financial_reason.chargeback_by_inactivity
            transaction.chargeback_by_inactivity!(chargeback_reason)
          end
        end

        @ad.update!(active: true, billed: true, status: :approved)
      end
    end

    def create_bonus_for(sponsor, generation)
      data = PERCENTAGES[generation.to_s.to_sym]
      cent_amount = data[:commission] * @amount

      if cent_amount.positive?
        sponsor.financial_transactions
               .create!(spreader: @user,
                       financial_reason: data[:reason],
                       moneyflow: :credit,
                       cent_amount: cent_amount)
      end
    end

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors
                            .bonus_receivers(PERCENTAGES.size)

      unilevel_nodes.is_a?(Array) ? unilevel_nodes.reverse.map(&:user) : [unilevel_nodes.user]
    end
  end
end
