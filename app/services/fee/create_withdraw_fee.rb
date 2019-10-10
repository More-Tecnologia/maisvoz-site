module Fee
  class CreateWithdrawFee

    def initialize(withdraw, fee)
      @withdraw = withdraw
      @fee = fee
    end

    def call
      ActiveRecord::Base.transaction do
        create_withdrawal_fee_financial_transaction
        create_system_financial_log
        update_balance
      end
    end

    private

    attr_reader :withdraw, :fee

    def create_withdrawal_fee_financial_transaction
      withdraw.financial_transactions.create!(user: user,
                                              spreader: User.find_morenwm_customer_user,
                                              financial_reason: FinancialReason.withdrawal_fee,
                                              cent_amount: fee,
                                              money_flow: :debit)
    end

    def create_system_financial_log
      system_log             = SystemFinancialLog.new
      system_log.description = "Taxa sobre saque ID: #{withdraw.id} de R$#{withdraw.gross_amount}"
      system_log.amount      = fee
      system_log.kind        = SystemFinancialLog.kinds[:fee]
      system_log.save!
    end

    def update_balance
      master_user.increment!(:available_balance_cents, fee * 1e2)
    end

    def master_user
      @master_user ||= User.find_by(username: master_username)
    end

    def master_username
      ENV['MASTER_FINANCIAL_ACCOUNT']
    end

    def h
      ActionController::Base.helpers
    end

  end
end
