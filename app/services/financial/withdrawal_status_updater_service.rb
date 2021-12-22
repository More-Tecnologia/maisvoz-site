module Financial
  class WithdrawalStatusUpdaterService < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        withdrawal.update!(status: status, updater_user: updater_user)
        case withdrawal.status.to_sym
        when :approved
          debit_withdrawal_gross_amount_from_user
          create_withdrawal_fee_financial_transaction
        when :refused, :canceled
          restore_credit
        end
        send_email_to_user
      end
    end

    private

    attr_reader :updater_user, :status, :withdrawal, :user, :withdrawal_fee

    def initialize(args, locale)
      @updater_user = args[:updater_user]
      @status = args[:status]
      @reason = args[:reason]
      @withdrawal = args[:withdrawal]
      @user = @withdrawal.user
      @withdrawal_fee = ENV['WITHDRAWAL_FEE'].to_f
      @locale = locale
    end

    def balance_decrement
      @balance_decrement ||= withdrawal.gross_amount_cents.to_d
    end

    def restore_credit
      amount = user.withdrawal_order_amount - withdrawal.gross_amount_cents
      withdrawal.user.update!(withdrawal_order_amount: amount)
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

    def send_email_to_user
      {
        approved: -> { WithdrawalsMailer.with(withdrawal: withdrawal, locale: @locale)
                                        .approved
                                        .deliver_later },
        refused: -> { WithdrawalsMailer.with(withdrawal: withdrawal, locale: @locale, reason: @reason)
                                       .rejected
                                       .deliver_later },
        canceled: -> { WithdrawalsMailer.with(withdrawal: withdrawal, locale: @locale)
                                        .canceled
                                        .deliver_later },
      }[withdrawal.status.to_sym].call

    end

    def release_blocked_balance
      currency = Currency.find_by(code: withdrawal.currency.downcase)
      return unless currency
      user.financial_operations.create!(currency: currency,
                                        financial_reason: FinancialReason.withdrawal_denial_reason,
                                        amount: withdrawal.gross_amount_cents)
    end
  end
end
