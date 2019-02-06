module Subscriptions
  class ClubMotorsAdd

    def initialize(form:)
      @form = form
    end

    def call
      ActiveRecord::Base.transaction do
        create_subscription
        activate_subscription
      end
    end

    private

    attr_reader :form, :subscription

    def create_subscription
      @subscription = ClubMotorsSubscription.create!(form.create_attributes)
    end

    def activate_subscription
      Subscriptions::ActivateClubMotors.new(subscription: subscription).call
    end

  end
end
