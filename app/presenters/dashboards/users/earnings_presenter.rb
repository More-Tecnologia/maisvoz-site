# frozen_string_literal: true

module Dashboards
  module Users
    class EarningsPresenter
      BONUS_FIELDS = %i[id cent_amount remaining_balance received_balance].freeze

      def initialize(user)
        @user = user
        @bonus_contracts = @user.bonus_contracts
                                .select(BONUS_FIELDS)
                                .active
      end

      def build
        {
          data: { earnings: earnings },
          labels: labels
        }
      end

      private

      def account_earnings_limit
        @bonus_contracts.sum(&:cent_amount)
      end

      def earnings
        {
          account_earnings_limit: account_earnings_limit,
          receivable_amount: receivable_amount,
          received_amount: received_amount
        }
      end

      def labels
        {
          account_earnings_limit: I18n.t(:account_earnings_limit),
          receivable_amount: I18n.t(:receivable_amount),
          received_amount: I18n.t(:received_amount)
        }
      end

      def receivable_amount
        @bonus_contracts.sum(&:remaining_balance)
      end

      def received_amount
        @bonus_contracts.sum(&:received_balance)
      end

    end
  end
end
