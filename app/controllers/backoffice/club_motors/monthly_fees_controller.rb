module Backoffice
  module ClubMotors
    class MonthlyFeesController < BackofficeController

      def index
        @monthly_fees = current_user.orders.monthly_fees.includes(club_motors_subscription: :car_model).includes(:payment_transactions)
      end

    end
  end
end
