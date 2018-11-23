module Backoffice
  module ClubMotors
    class MonthlyFeesController < BackofficeController

      def index
        @monthly_fees = current_user.orders.monthly_fees
      end

    end
  end
end
