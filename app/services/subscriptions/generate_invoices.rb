module Subscriptions
  class GenerateInvoices

    def initialize(subscriptions = ClubMotorsSubscription.active_subscriptions)
      @subscriptions = subscriptions
    end

    def call
      subscriptions.each do |subscription|
        generate_invoice(subscription)
      end
    end

    attr_reader :subscriptions

    def generate_invoice(subscription)
      Subscriptions::CreateMonthlyInvoice.new(subscription).call
    end

  end
end
