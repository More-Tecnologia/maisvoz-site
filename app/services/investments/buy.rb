module Investments
  class Buy

    def initialize(user:, investment:, quantity:)
      @user = user
      @investment = investment
      @quantity = quantity
    end

    def call
      investment.with_lock do
        create_investment_share
        create_order
        update_investment
      end
    end

    private

    attr_reader :user, :investment, :quantity, :order

    def create_investment_share
      @investment_share = InvestmentShare.new.tap do |share|
        share.user               = user
        share.investment         = investment
        share.status             = InvestmentShare.statuses[:pending]
        share.name               = investment.name
        share.quantity           = quantity
        share.gross_amount_cents = total_cents
        share.net_amount_cents   = total_cents * 0.9

        share.save!
      end
    end

    def create_order
      @order = Order.new.tap do |cart|
        cart.user           = user
        cart.type           = Order.types[:participation_acc]
        cart.expire_at      = Time.zone.today + 1.day
        cart.payable        = @investment_share
        cart.subtotal_cents = total_cents
        cart.total_cents    = total_cents

        cart.save!
      end

      Shopping::CheckoutCart.new(cart: @order).call
    end

    def update_investment
      investment.shares_available -= quantity
      investment.save!
    end

    def total_cents
      quantity * investment.price_cents
    end

  end
end
