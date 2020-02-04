module Backoffice
  class PaymentBlockNotificationsController < ApiController

    def create
      Payment::BlockNotificationService.call(transaction_code: transaction_code)
    rescue StandardError => error
      render_error(:unprocessable_entity, error.message)
    end

    private

    def transaction_code
      notification = params.require(:payment_block_notification)
                           .permit(:transaction_code)
      notification[:transaction_code]
    end

  end
end
