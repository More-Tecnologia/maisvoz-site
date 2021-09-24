module Backoffice
  class PaymentTransactionsController < BackofficeController
    include Backoffice::PaymentTransactionsHelper

    def show
      @payment_transaction = PaymentTransaction.find_by_hashid(params[:id])
      @payment_transaction.wallet_address = get_wallet_address_from_gateway(@payment_transaction)
    rescue StandardError => error
      flash[:error] = error.message
      redirect_to backoffice_orders_path
    end
  end
end
