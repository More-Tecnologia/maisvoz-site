module Payment
  class BlockCheckoutService < ApplicationService
    def call
      transaction = nil
      ActiveRecord::Base.transaction do
        #checkout = payment_transaction_request
        transaction = payment_transaction('transaction_code' => SecureRandom.hex, 'wallet_address' => SecureRandom.hex)
        order.update!(status: :pending_payment, payment_type: @payment_method)
      end
      transaction
    end

    private

    attr_accessor :order, :user, :amount

    def initialize(args)
      @order = args[:order]
      @user = @order.user
      @payment_method = args[:payment_method]
    end

    def payment_transaction_request
      params = { amount: order.total_cents / 100.0,
                 current_currency: ENV['CURRENT_CURRENCY'],
                 payment_currency: @payment_method,
                 name: @user.username,
                 description: @order.hashid,
                 payment_method: @payment_method }

      Webhooks::PaymentGateway::TransactionCreatorService.call(params)
    end

    def payment_transaction(response)
      order.create_payment_transaction!(amount: response['amount'],
                                        transaction_id: response['transaction_code'],
                                        wallet_address: response['wallet_address'],
                                        provider_response: response)
    end
  end
end
