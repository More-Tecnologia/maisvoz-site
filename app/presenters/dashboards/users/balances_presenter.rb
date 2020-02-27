# frozen_string_literal: true

module Dashboards
  module Users
    class BalancesPresenter

      def initialize(user)
        @user = user
      end

      def build
        {
          data: { balances: balances },
          labels: labels
        }
      end

      private

      def available_balance
        @user.available_balance
      end

      def balance
        available_balance + blocked_balance
      end

      def balances
        {
          balance: balance,
          available_balance: available_balance,
          blocked_balance: blocked_balance
        }
      end

      def blocked_balance
        @user.blocked_balance
      end

      def labels
        {
          available_balance: I18n.t(:available_balance),
          balance: I18n.t(:balance),
          blocked_balance: I18n.t(:blocked_balance)
        }
      end

    end
  end
end
