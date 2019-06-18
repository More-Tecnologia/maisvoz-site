module Subscriptions
  class CalculateClubMotorsFee

    ASSISTANCE_24H_PRICE = {
      gold: 25,
      silver: 20,
      bronze: 15
    }

    def initialize(fee:, plan_package:, assistance_24h:)
      @fee            = fee
      @plan_package   = plan_package.to_sym
      @assistance_24h = assistance_24h
    end

    def call
      fee.send("#{dic[plan_package]}_fee_cents") + assistance_24h_price * 100
    end

    private

    attr_reader :fee, :plan_package, :assistance_24h

    def dic
      {
        gold: 'premium',
        silver: 'master',
        bronze: 'standard'
      }
    end

    def assistance_24h_price
      return 0 unless assistance_24h

      ASSISTANCE_24H_PRICE[plan_package]
    end

  end
end
