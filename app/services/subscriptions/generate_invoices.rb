module Subscriptions
  class GenerateInvoices

    def call
      subscriptions.each do |subscription|
        CreateMonthlyInvoiceWorker.perform_async(subscription.id)
      end
    end

    private

    def subscriptions
      ClubMotorsSubscription.active_subscriptions.where('next_billing_date <= ?', Date.today)
    end

  end
end
