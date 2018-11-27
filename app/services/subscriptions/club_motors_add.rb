module Subscriptions
  class ClubMotorsAdd

    def initialize(form:)
      @form = form
    end

    def call
      ActiveRecord::Base.transaction do
        create_subscription
        update_subscription
        create_invoice
      end
    end

    private

    attr_reader :form, :subscription

    def create_subscription
      @subscription = ClubMotorsSubscription.create!(form.create_attributes)
    end

    def update_subscription
      subscription.status               = status
      subscription.type                 = ClubMotorsSubscription.types[:clubmotors]
      subscription.billing_day_of_month = billing_day_of_month
      subscription.price_cents          = subscription.calculate_price_cents
      subscription.next_billing_date    = now

      subscription.save!
    end

    def create_invoice
      Subscriptions::CreateMonthlyInvoice.new(subscription).call
    end

    def status
      if form.user.club_motors_subscriptions.where(status: :active).any?
        ClubMotorsSubscription.statuses[:pending]
      else
        ClubMotorsSubscription.statuses[:active]
      end
    end

    def billing_day_of_month
      [now.day, 28].min
    end

    def now
      @now ||= Time.zone.now
    end

  end
end
