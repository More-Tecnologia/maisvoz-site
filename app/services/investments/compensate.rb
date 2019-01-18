module Investments
  class Compensate

    def initialize(investment_share:)
      @investment_share = investment_share
    end

    def call
      update_investment_share
    end

    private

    attr_reader :investment_share

    def update_investment_share
      investment_share.active!
    end

  end
end
