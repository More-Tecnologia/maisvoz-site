module Financial
  class UpdaterWithdrawalStatusService < ApplicationService

    def call
      ActiveRecord::Base.transaction do
        withdrawal.update!(status: status, updater_user: updater_user)
        return restore_credit_and_send_email_to_user if withdrawal.refused?
        if withdrawal.approved?
          debit_withdrawal_gross_amount_from_user
          create_withdrawal_fee_financial_transaction
          notify_withdrawal_user_by_email
        end
      end
    end

    private

    attr_reader :updater_user, :status, :withdrawal, :user, :withdrawal_fee

    def initialize(args)
      @updater_user = args[:updater_user]
      @status = args[:status]
      @withdrawal = args[:withdrawal]
      @user = @withdrawal.user
      @withdrawal_fee = ENV['WITHDRAWAL_FEE'].to_f
    end

    def restore_credit_and_send_email_to_user
      amount = user.withdrawal_order_amount - withdrawal.gross_amount_cents
      withdrawal.user.update!(withdrawal_order_amount: amount)
      WithdrawalsMailer.with(withdrawal: withdrawal).rejected.deliver_later
    end

    def debit_withdrawal_gross_amount_from_user
      user.financial_transactions.create!(spreader: User.find_morenwm_customer_user,
                                          financial_reason: FinancialReason.withdrawal,
                                          cent_amount: withdrawal.gross_amount_cents,
                                          moneyflow: :debit) if withdrawal.gross_amount_cents > 0
      new_withdrawal_order_amount = user.withdrawal_order_amount - withdrawal.gross_amount_cents
      user.update!(withdrawal_order_amount: new_withdrawal_order_amount)
    end

    def create_withdrawal_fee_financial_transaction
      admin_user = User.find_morenwm_customer_admin
      admin_user.financial_transactions.create!(spreader: withdrawal.user,
                                                financial_reason: FinancialReason.withdrawal_fee,
                                                cent_amount: withdrawal_fee,
                                                moneyflow: :credit) if withdrawal_fee > 0
    end

    def notify_withdrawal_user_by_email
      WithdrawalsMailer.with(withdrawal: withdrawal).approved.deliver_later
    end

  end
end
