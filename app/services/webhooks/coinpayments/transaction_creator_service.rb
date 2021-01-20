# frozen_string_literal: true

module Webhooks::Coinpayments
  class TransactionCreatorService < Webhooks::BasicHookService
    def call
      response = create_transaction_request
      raise response.dig('error') unless success?(response)
      response
    rescue StandardError => error
      raise_error_on_create_transaction(error.message)
    end

    private

    ENDPOINT = 'https://www.coinpayments.net/api.php'.freeze

    def initialize(args)
      @amount = args[:amount].to_f
      @current_currency = args[:current_currency]
      @payment_currency = args[:payment_currency]
      @buyer_email = args[:buyer_email]
    end

    def create_transaction_request
      response = HTTParty.post(ENDPOINT, headers: headers, body: params)

      raise response.code.to_s unless response.success?

      response.parsed_response
    end

    def headers
      private_key = Rails.application.credentials.coinpayments_private_key
      hmac = OpenSSL::HMAC.hexdigest('SHA512', private_key, URI.encode_www_form(params))

      { 'Content-Type': 'application/x-www-form-urlencoded', 'HMAC': hmac }
    end

    def params
      {
        version: 1,
        key: Rails.application.credentials.coinpayments_public_key,
        cmd: 'create_transaction',
        amount: @amount,
        currency1: @current_currency,
        currency2: @payment_currency,
        buyer_email: @buyer_email,
        format: 'json'
      }
    end

    def success?(response)
      error = response.dig('error').to_s.downcase
      error == 'ok'
    end

    def raise_error_on_create_transaction(message)
      error = I18n.t('defaults.errors.coinpayments', error: message)
      raise(error)
    end
  end
end
