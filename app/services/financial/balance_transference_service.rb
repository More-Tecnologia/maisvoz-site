module Financial
  class BalanceTransferenceService < ApplicationService
    def call
      validate_source_user_balance!
      validate_tranfer_value!
      ActiveRecord::Base.transaction do
        source_transaction = debit_transfer_value_from_source_user
        credit_transfer_value_to_destination_user(source_transaction)
        create_transfer_fee(source_transaction)
      end
    end

    private

    TRANSFER_FEE = 0.05

    def initialize(args)
      @destination_user = args[:destination_user]
      @source_user = args[:source_user]
      @transfer_value = args[:transfer_value].to_f
      @transfer_value_fee = @transfer_value * TRANSFER_FEE
      @transfer_balance = @transfer_value - @transfer_value_fee
      @balance_transference = FinancialReason.balance_transference
    end

    def validate_tranfer_value!
      transfer_value_minimum = greater_order_value_from_the_source_user
      return if @transfer_value > transfer_value_minimum

      raise I18n.t('errors.messages.transfer_value_minimum',
                   value: transfer_value_minimum)
    end

    def greater_order_value_from_the_source_user
      contract_values = @source_user.bonus_contracts
                                    .active
                                    .yield_contracts
                                    .pluck(:cent_amount)

      contract_values.max.to_f / 100.0
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

    def credit_transfer_value_to_destination_user(source_transaction)
      @destination_user.financial_transactions
                       .create!(spreader: @source_user,
                                financial_reason: @balance_transference,
                                cent_amount: @transfer_balance,
                                source_financial_transaction: source_transaction)
      @destination_user.increment!(:transference_balance, @transfer_balance)
    end

    def create_transfer_fee(source_transaction)
      admin = User.find_morenwm_customer_admin

      admin.financial_transactions
           .create!(financial_reason: FinancialReason.balance_transference_fee,
                    cent_amount: @transfer_value_fee,
                    moneyflow: :credit,
                    source_financial_transaction: source_transaction) if @transfer_value_fee > 0
    end
  end
end
