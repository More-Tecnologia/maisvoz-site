module Subscriptions
  class GenerateInvoices

    def call
      subscriptions.each do |subscription|
        CreateMonthlyInvoiceWorker.perform_async(subscription.id)
      end
    end

    private

    def subscriptions
      ClubMotorsSubscription.active_subscriptions.where('next_billing_date <= ?', 10.days.from_now.to_date)
    end

  end
end
