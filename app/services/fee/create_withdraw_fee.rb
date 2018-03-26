module Fee
  class CreateWithdrawFee

    def initialize(withdraw, fee)
      @withdraw = withdraw
      @fee = fee
    end

    def call
      create_entry
      update_balance
    end

    private

    attr_reader :withdraw, :fee

    def create_entry
      FinancialEntry.new.tap do |entry|
        entry.user        = master_user
        entry.description = "Taxa de #{h.number_to_currency fee} sobre o saque ID: #{withdraw.id}"
        entry.amount      = fee
        entry.balance     = master_user.balance + fee
        entry.kind        = FinancialEntry.kinds[:withdrawal_fee]
        entry.save!
      end
    end

    def update_balance
      master_user.increment!(:available_balance_cents, fee * 1e2)
    end

    def master_user
      @master_user ||= User.find(master_id)
    end

    def master_id
      AppConfig.get('MASTER_FINANCIAL_ACCOUNT_ID')
    end

    def h
      ActionController::Base.helpers
    end

  end
end
