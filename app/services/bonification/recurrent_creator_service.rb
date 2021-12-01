module Bonification
  class RecurrentCreatorService < ApplicationService
    def call
      sponsors.each_with_index do |sponsor, index|
        next if sponsor.admin?

        transaction = create_recurrent_bonus_for(sponsor, index + 1)
        contracts = sponsor.bonus_contracts.active.reject(&:max_gains?)
        unless contracts.any?
          chargeback_reason = transaction.financial_reason.chargeback_by_max_gains
          transaction.chargeback_by_inactivity!(chargeback_reason)
        elsif sponsor.inactive?
          chargeback_reason = transaction.financial_reason.chargeback_by_inactivity
          transaction.chargeback_by_inactivity!(chargeback_reason)
        end
      end
    end

    private

    PERCENTAGES = { '1': 0.15,
                    '2': 0.10,
                    '3': 0.05 }.freeze

    def initialize(args)
      @user = args[:user]
      @amount = args[:transaction].cent_amount
    end

    def sponsors
      unilevel_nodes = @user.unilevel_node
                            .ancestors
                            .bonus_receivers(PERCENTAGES.size)

      unilevel_nodes.is_a?(Array) ? unilevel_nodes.reverse.map(&:user) : [unilevel_nodes.user]
    end

    def create_recurrent_bonus_for(sponsor, generation)
      cent_amount = @amount * PERCENTAGES[generation.to_s.to_sym]

        sponsor.financial_transactions
               .create!(spreader: @user,
                        financial_reason: FinancialReason.matching_bonus,
                        moneyflow: :credit,
                        cent_amount: cent_amount,
                        bonus_contract: sponsor.bonus_contracts.last)
    end
  end
end
