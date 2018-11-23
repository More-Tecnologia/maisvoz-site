module Tasks
  class CheckPendingBoleto

    def self.call
      Order.pending_payment.find_each do |order|
        Payment::Bradesco::CompensateOrder.new(order).call
      end
    end

  end
end
