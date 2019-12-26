module Tasks
  class CheckPendingBoleto  < ApplicationService

    def call
      auth_key = Payment::Bradesco::GetAuthKey.call

      Order.pending_payment.where.not(expire_at: nil).find_each do |order|
        Payment::Bradesco::CompensateOrder.new(order, auth_key).call
      end
    end

  end
end
