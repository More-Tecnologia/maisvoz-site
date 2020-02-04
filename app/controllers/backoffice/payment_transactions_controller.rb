module Backoffice
  class PaymentTransactionsController < BackofficeController

    def show
      @payment_transaction = PaymentTransaction.find_by(params.slice[:id])
    rescue Exception => error
      flash[:error] = error.message
      redirect_to backoffice_orders_path
    end

  end
end
