class CreateMonthlyInvoiceWorker
  include Sidekiq::Worker

  def perform(subscription_id)
    subscription = ClubMotorsSubscription.find(subscription_id)

    Subscriptions::CreateMonthlyInvoice.new(subscription).call
  end
end
