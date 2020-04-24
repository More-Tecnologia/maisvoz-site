# frozen_string_literal: true

module Dashboards
  module Admins
    class PaymentPresenter

      def build
        {
          data: { payment: payment },
          labels: labels
        }
      end

      private

      def payment
        {
          balance: Order.balance.count,
          admin: Order.admin.count,
          admin_nb: Order.admin_nb.count,
          voucher: Order.voucher.count,
          btc: Order.btc.count,
          total_payments: Order.completed.count
        }
      end

      def labels
        {
          balance: I18n.t(:balance),
          admin: I18n.t(:admin),
          admin_nb: I18n.t(:admin_nb),
          voucher: I18n.t(:voucher),
          btc: I18n.t(:btc),
          total_payments: I18n.t(:total_payments)
        }
      end

    end
  end
end
