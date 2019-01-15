module Investments
  class Compensate

    def initialize(investment_share:)
      @investment_share = investment_share
    end

    def call
      investment.with_lock do
        update_investment_share
        update_investment
      end
    end

    private

    delegate :investment, to: :investment_share

    attr_reader :investment_share

    def update_investment_share
      investment_share.active!
    end

    def update_investment
      investment.shares_available -= investment_share.quantity
      investment.save!
    end

  end
end
