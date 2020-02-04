module Payment
  class BlockNotificationService < ApplicationService

    def call
      payment_transaction.paid!
      PaymentCompensationWorker.perform_async(payment_transaction.order.id)
    rescue Exception => error
      register_notification_error(error.message)
      raise Exception, error.message
    end

    private

    attr_accessor :transaction_code, :payment_transaction

    def initialize(args)
      @transaction_code = args[:transaction_code]
      @payment_transaction = find_payment_transaction
    end

    def find_payment_transaction
      PaymentTransaction.started
                        .includes(order: [:user])
                        .where(transaction_id: transaction_code)
                        .first
    end

    def register_notification_error(error_message)
      payment_transaction.update_attribute(:provider_response, error_message)
    end

  end
end
