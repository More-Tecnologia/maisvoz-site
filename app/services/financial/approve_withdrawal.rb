module Financial
  class ApproveWithdrawal

    prepend SimpleCommand

    def initialize(creator, withdrawal)
      @creator = creator
      @withdrawal = withdrawal
      @user = withdrawal.user
    end

    def call
      user.lock!
      ActiveRecord::Base.transaction do
        create_withdrawal_financial_transaction
        create_withdrawal_fee_financial_transaction
        send_notification
      end
    end

    private

    attr_reader :creator, :withdrawal, :user

    def create_withdrawal_financial_transaction
      withdrawal.financial_transactions.create!(user: user,
                                                spreader: User.find_morenwm_customer_user,
                                                financial_reason: FinancialReason.withdrawal,
                                                cent_amount: withdrawal.gross_amount,
                                                money_flow: :debit)
    end

    def create_withdrawal_fee_financial_transaction
      Fee::CreateWithdrawFee.new(withdrawal, fee).call
    end

    def send_notification
      WithdrawalsMailer.with(withdrawal: withdrawal).approved.deliver_later
    end

    def fee
      @fee ||= ENV['WITHDRAWAL_FEE'].to_f
    end
  end
end
