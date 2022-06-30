# frozen_string_literal: true

module Bonification
  class MasterLeaderCreatorService < ApplicationService
    PERCENTAGE = 0.0005

    def call
      sponsors.each do |sponsor|
        next if sponsor.admin?
        next unless sponsor.master_leader

        transactions = create_master_leader_bonus_for(sponsor)
        if sponsor.inactive?
          chargeback_reason = FinancialReason.chargeback_by_inactivity
          transactions.each do |transaction|
            transaction.chargeback_by_inactivity!(chargeback_reason)
          end
        end
      end
    end

    def initialize(args)
      order = args[:order]
      @user = order.user
      @amount = order.total_cents
    end

    private

    def create_master_leader_bonus_for(sponsor)
      cent_amount = @amount * PERCENTAGE
      Bonification::GenericBonusCreatorService.call({
        amount: cent_amount,
        spreader: @user,
        sponsor: sponsor,
        reason: FinancialReason.master_leader_bonus,
      })
    end

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors

      unilevel_nodes.reverse.map(&:user).uniq
    end
  end
end
