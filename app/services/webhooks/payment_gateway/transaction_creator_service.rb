module Webhooks::PaymentGateway
  class TransactionCreatorService < Webhooks::BasicHookService
    def call
      transaction_creator_request
    rescue StandardError => error
      error_message = I18n.t('defaults.errors.payment_gateway_transaction', error: error.message)

      raise(error_message)
    end

    private

    ENDPOINT = ENV['PAYMENT_BLOCK_CHECKOUT_URL'].freeze

    def initialize(args)
      @amount = args[:amount]
      @current_currency = args[:current_currency] || ENV['CURRENT_CURRENCY']
      @payment_currency = args[:payment_currency]
      @name = args[:name]
      @description = args[:description]
      @payment_method = args[:payment_method]
    end

    def transaction_creator_request
      headers = { Authorization: ENV['PAYMENT_BLOCK_AUTHORIZATION_KEY'] }

      response = HTTParty.post(ENDPOINT, headers: headers, body: params)
      return response.parsed_response.dig('data') if response.success?

      raise(response.parsed_response.dig('message'))
    end

    def params
      {
        name: @name,
        description: @description,
        amount: @amount,
        current_currency: @current_currency,
        payment_currency: @payment_currency,
        payment_method: @payment_method
      }
    end
  end
end
