# frozen_string_literal: true

module Webhooks
  module Pagstar
    class GetAccessTokenService < ApplicationService
      ENDPOINT = ENV['PAGSTAR_API_URL'] + '/identity/partner/login'
      HEADERS = { 'Content-Type': 'application/json' }.freeze
      PARAMS = {
        email: ENV['PAGSTAR_LOGIN'],
        access_key: ENV['PAGSTAR_ACCESS_KEY']
      }.to_json.freeze

      private

      def call
        login_request
      rescue StandardError => error
        raise_error_on_login(error.message)
      end

      def login_request
        response = HTTParty.post(ENDPOINT, headers: HEADERS, body: PARAMS)
        
        raise response.code.to_s unless response.success?
  
        response.parsed_response['data']['access_token']
      end

      def raise_error_on_login(message)
        error = I18n.t('defaults.errors.pagstar.token', error: message)
        raise(error)
      end
    end
  end
end

