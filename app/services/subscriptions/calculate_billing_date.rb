module Subscriptions
  class CalculateBillingDate

    def initialize(date = Time.zone.today)
      @date = date
    end

    def call
      if day < 10
        date.change(day: 10)
      elsif day < 18
        date.change(day: 18)
      elsif day < 28
        date.change(day: 28)
      else
        (date + 1.month).change(day: 10)
      end
    end

    private

    attr_reader :date

    delegate :day, to: :date

  end
end
