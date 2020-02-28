# frozen_string_literal: true

module Dashboards
  module Admins
    class WithdrawalsPresenter

      def build
        {
          data: { withdrawals: withdrawals },
          labels: labels
        }
      end

      private

      def withdrawals
        {
          pending: Withdrawal.pending.count,
          approved: Withdrawal.approved.count,
          refused: Withdrawal.refused.count,
          waiting: Withdrawal.waiting.count,
          canceled: Withdrawal.canceled.count,
          total_withdrawals: Withdrawal.count
        }
      end

      def labels
        {
          pending: I18n.t(:pending),
          approved: I18n.t(:approved),
          refused: I18n.t(:refused),
          waiting: I18n.t(:waiting),
          canceled: I18n.t(:canceled),
          total_withdrawals: I18n.t(:total_withdrawals)
        }
      end

    end
  end
end
