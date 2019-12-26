module Payment
  class RemoveExpiredBoleto < ApplicationService

    def call
      ActiveRecord::Base.transaction do
        Order.pending_payment.where('expire_at < ?', 20.days.ago).find_each do |order|
          order.payment_transaction.destroy!
          order.expire_at = nil
          order.save!
        end
      end
    end

  end
end
