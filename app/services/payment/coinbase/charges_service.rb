module Payment::Coinbase
  class ChargesService < ApplicationService
    def call
      raise 'Order do not persisted' unless order.persisted?

      response = request_charge_transaction
      raise_error(response) unless response.success?
      ActiveRecord::Base.transaction do
        order.pending_payment!
        payment_transaction(response.parsed_response)
      end
    end

    private

    attr_accessor :order, :user

    def initialize(args)
      @order = args[:order]
      @user = order.user
    end

    def request_charge_transaction
      endpoint = ENV['PAYMENT_GATEWAY_CHARGES_URL']
      headers = { Authorization: ENV['PAYMENT_BLOCK_AUTHORIZATION_KEY'] }
      params = { name: @user.email,
                 description: @order.hashid,
                 amount: @order.total_value.to_s,
                 currency: ENV['CURRENT_CURRENCY'] }

      HTTParty.post(endpoint, body: params, headers: headers)
    end

    def raise_error(response)
      error = response.parsed_response ? response.parsed_response['message'] : response.code.to_s
      raise error
    end

    def payment_transaction(response)
      PaymentTransaction.create!(order: order,
                                 amount: response.dig('data', 'amount'),
                                 transaction_id: response.dig('data', 'transaction_code'),
                                 wallet_address: response.dig('data', 'wallet_address'),
                                 provider_response: response)
    end
  end
end
