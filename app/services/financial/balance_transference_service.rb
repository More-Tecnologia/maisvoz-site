module Financial
  class BalanceTransferenceService < ApplicationService
    def call
      validate_source_user_balance!
      ActiveRecord::Base.transaction do
        debit_transfer_value_from_source_user
        credit_transfer_value_to_destination_user
      end
    end

    private

    def initialize(args)
      @destination_user = args[:destination_user]
      @source_user = args[:source_user]
      @transfer_value = args[:transfer_value].to_f
      @balance_transference = FinancialReason.balance_transference
    end

    def validate_source_user_balance!
      return if @source_user.available_balance >= @transfer_value

      raise I18n.t('errors.messages.not_enough_balance')
    end

    def debit_transfer_value_from_source_user
      @source_user.financial_transactions
                  .create!(financial_reason: @balance_transference,
                           cent_amount: @transfer_value,
                           moneyflow: :debit)
    end

    def credit_transfer_value_to_destination_user
      @destination_user.financial_transactions
                       .create!(spreader: @source_user,
                                financial_reason: @balance_transference,
                                cent_amount: @transfer_value)
      @destination_user.update!(transference_balance: @transfer_value)
    end
  end
end
