# frozen_string_literal: true

module Api::V1
  class CoinpaymentsNotificationsController < ApiController

    PAYMENT_COMPLETED_STATUS = 100
    PAYMENT_QUEUED_STATUS = 2

    def create
      head :unprocessable_entity and return unless paid?

      transaction = PaymentTransaction.started.find_by(transaction_id: params[:txn_id])
      transaction.paid_with_provider_response!(params)

      PaymentCompensationWorker.perform_async(transaction.order_id)
    end

    private

    def valid_params
      params.permit(:ipn_version, :ipn_type, :ipn_mode, :ipn_id, :merchant,
                    :status, :status_text, :txn_id, :currency1, :currency2,
                    :amount1, :amount2, :fee)
            .to_hash
    end

    # override
    def authenticate_request
      data = URI.encode_www_form(valid_params)
      hmac = OpenSSL::HMAC.hexdigest('SHA512', ENV['AUTHORIZATION_KEY'], data)

      head :unauthorized unless hmac == request.headers['HMAC']
    end

    def paid?
      transaction_status = params[:status].to_f

      transaction_status == PAYMENT_QUEUED_STATUS ||
      transaction_status >= PAYMENT_COMPLETED_STATUS
    end
  end
end
