module Backoffice
  module PaymentTransactionsHelper

    def get_wallet_address_from_gateway(payment_transaction)
      response = get_wallet_address(payment_transaction.transaction_id)
      json = JSON.parse(response.body).deep_symbolize_keys
      json[:data][:wallet_address]
    rescue Exception
      ''
    end

    def get_wallet_address(transaction_id)
      url = "#{ENV['GATEWAY_WALLET_URL']}/#{transaction_id}"
      headers = { 'Authorization': ENV['PAYMENT_BLOCK_AUTHORIZATION_KEY'], 'Content-Type': 'application/json' }
      params = { transaction_code: transaction_id }.to_json
      HTTParty.get(url, headers: headers, body: params)
    end

  end
end
