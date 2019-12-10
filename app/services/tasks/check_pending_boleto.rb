module Tasks
  class CheckPendingBoleto  < ApplicationService

    def call
      auth_key = Payment::Bradesco::GetAuthKey.call

      Order.pending_payment.boleto.find_each do |order|
        Payment::Bradesco::CompensateOrder.new(order, auth_key).call
      end
    end

  end
end
