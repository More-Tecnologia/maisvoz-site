module Fee
  class CreateSystemFee

    def initialize(order)
      @order = order
    end

    def call
      create_entry
      update_balance
    end

    private

    attr_reader :order

    def create_entry
      FinancialEntry.new.tap do |entry|
        entry.user        = master_user
        entry.order       = order
        entry.description = "Taxa de #{h.number_to_currency amount} sobre a fatura ID: #{order.id}"
        entry.amount      = amount
        entry.balance     = master_user.balance + amount
        entry.kind        = FinancialEntry.kinds[:fee]
        entry.save!
      end
    end

    def update_balance
      master_user.increment!(:available_balance_cents, amount * 1e2)
    end

    def master_user
      @master_user ||= User.find_by(username: master_username)
    end

    def amount
      @amount ||= order.total.to_d * fee
    end

    def fee
      @fee ||= AppConfig.get('SYSTEM_FEE').to_d
    end

    def master_username
      AppConfig.get('MASTER_FINANCIAL_ACCOUNT')
    end

    def h
      ActionController::Base.helpers
    end

  end
end
