# frozen_string_literal: true

module Bonification
  class MasterLeaderCreatorService < ApplicationService
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

    def calculate_percentages(sponsoreds)
      case sponsoreds
      when 0..10_000
        0.00010
      when 10_001..20_000
        0.00015
      when 20_001..30_000
        0.00025
      when 30_001..40_000
        0.00035
      else
        0.00040
      end
    end

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors

      unilevel_nodes.reverse.map(&:user)
    end

    def sponsoreds_count(sponsor)
      sponsor.unilevel_node
             .subtree
             .from_depth(sponsor.unilevel_node.depth)
             .includes(user: %i[sponsor career])
             .where.not(id: sponsor.id)
             .count
    end

    def create_master_leader_bonus_for(sponsor)
      sponsoreds = sponsoreds_count(sponsor)
      cent_amount = @amount * calculate_percentages(sponsoreds)
      Bonification::GenericBonusCreatorService.call({
        amount: cent_amount,
        spreader: @user,
        sponsor: sponsor,
        reason: FinancialReason.master_leader_bonus,
      })
    end
  end
end
