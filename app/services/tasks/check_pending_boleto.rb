module Tasks
  class CheckPendingBoleto

    def self.call
      auth_key = Payment::Bradesco::GetAuthKey.call

      Order.pending_payment.find_each do |order|
        Payment::Bradesco::CompensateOrder.new(order, auth_key).call
      end
    end

  end
end
