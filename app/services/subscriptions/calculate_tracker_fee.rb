module Subscriptions
  class CalculateTrackerFee

    MONTHLY_FEE = 60.0
    MONTHLY_FEE_ENTREPRENEUR = 40.0

    def initialize(user:, format: :regular)
      @user = user
      @format = format
    end

    def call
      if user.empreendedor?
        format_value MONTHLY_FEE_ENTREPRENEUR
      else
        format_value MONTHLY_FEE
      end
    end

    private

    attr_reader :user, :format

    def format_value(value)
      if format == :cents
        (value * 100).to_i
      else
        value
      end
    end

  end
end
