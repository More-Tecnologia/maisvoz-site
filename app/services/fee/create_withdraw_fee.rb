module Fee
  class CreateWithdrawFee

    def initialize(withdrawal, fee)
      @withdrawal = withdrawal
      @fee = fee
    end

    def call
      ActiveRecord::Base.transaction do
        create_withdrawal_fee_financial_transaction
      end
    end

    private

    attr_reader :withdrawal, :fee

    def create_withdrawal_fee_financial_transaction
      withdrawal.user.financial_transactions.create!(spreader: User.find_morenwm_customer_user,
                                                     financial_reason: FinancialReason.withdrawal_fee,
                                                     cent_amount: fee,
                                                     moneyflow: :debit)
    end

  end
end
