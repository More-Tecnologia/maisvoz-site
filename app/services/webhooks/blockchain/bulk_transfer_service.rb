module Webhooks::Blockchain
  class BulkTransferService < ApplicationService
    def call
      response = bulk_transfer_request
      return response.parsed_response if success?(response)

      raise(response.parsed_response)
    end

    private

    def initialize(args)
      @guid = args[:guid]
      @main_password = args[:main_password]
      @second_password = args[:second_password]
      @recipients = args[:recipients]
    end

    def bulk_transfer_request
      endpoint = "https://blockchain.info/merchant/#{@guid}/sendmany"
      headers = { 'Content-Type': 'application/json' }
      query =   { password: @main_password,
                  recipients: @recipients }
      query.merge!(second_password: @second_password) if @second_password.present?

      HTTParty.get(endpoint, body: query.to_json, headers: headers)
    end

    def success?(response)
      response.parsed_response.dig('tx_hash').present?
    end
  end
end
