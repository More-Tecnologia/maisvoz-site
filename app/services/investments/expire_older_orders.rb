module Investments
  class ExpireOlderOrders

    prepend SimpleCommand

    def call
      Order.participation_acc.where('expire_at <= ?', 3.days.ago.to_date).find_each do |order|
        update_order(order)
      end
    end

    private

    def update_order(order)
      investment_share = order.payable
      investment = investment_share.investment

      investment.with_lock do
        investment.shares_available += investment_share.quantity
        investment.save!

        investment_share.expired_payment!

        order.expired!
      end
    end

  end
end
