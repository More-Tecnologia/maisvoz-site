module Backoffice
  module ClubMotors
    class MonthlyFeesController < BackofficeController

      def index
        @monthly_fees = current_user.orders.monthly_fees.order(created_at: :desc).includes(:payment_transactions)
      end

    end
  end
end
