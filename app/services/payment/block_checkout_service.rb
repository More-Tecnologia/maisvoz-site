module Payment
    class BlockCheckoutService < ApplicationService

      def call
        payment_transaction = nil
        ActiveRecord::Base.transaction do
          checkout = request_block_checkout_transaction
          payment_transaction = create_payment_transaction(checkout = nil)
          order.pending_payment!
        end
        payment_transaction
      end

      private

      attr_accessor :order, :user, :amount

      def initialize(args)
        @order = args[:order]
        @user = order.user
      end

      def request_block_checkout_transaction
        response = notify_payment_block
        raise_error(response) unless success?(response.code)
        body = JSON.parse(response.body)
        body['data']
      end

      def create_payment_transaction(checkout)
        PaymentTransaction.create!(order: order,
                                   amount: amount,
                                   transaction_id: checkout['transaction_code'],
                                   wallet_address: checkout['wallet_address'])
      end

      def convert_to_currency_coin(total)
        currency_exchange_rate = request_currency_exchange_rate
        total / (currency_exchange_rate.to_f * 100.0)
      end

      def calculate_amount
        @amount ||= convert_to_currency_coin(order.total_cents)
      end

      def request_currency_exchange_rate
        currency = ENV['CURRENT_CURRENCY']
        uri = URI("https://api.coinbase.com/v2/prices/spot?currency=#{currency}")
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        data['data']['amount']
      end

      def success?(response_code)
        response_code.to_s.start_with?('2')
      end

      def raise_error(response)
        body = JSON.parse(response.body)
        raise Exception, body['message']
      end

      def notify_payment_block
        uri = URI(ENV['PAYMENT_BLOCK_CHECKOUT_URL'])
        params = { amount: calculate_amount }.to_json
        headers = { Authorization: ENV['PAYMENT_BLOCK_AUTHORIZATION_KEY'] }
        Net::HTTP.post(uri, params, headers)
      end

    end
  end
