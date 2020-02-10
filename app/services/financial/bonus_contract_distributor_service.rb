module Financial
  class BonusContractDistributorService < ApplicationService

    def call
      return unless @first_active_bonus_contract
      bonus_amount = @financial_transaction.cent_amount
      bonus_amount -= @chargeback.cent_amount if @chargeback
      return if bonus_amount <= 0
      ActiveRecord::Base.transaction do
        distribute_bonus_to_contracts(bonus_amount)
        @user.inactivate! unless @active_bonus_contracts.any?(&:active?)
      end
    end

    private

    def initialize(args)
      @financial_transaction = args[:financial_transaction]
      @chargeback = @financial_transaction.chargeback
      @user = @financial_transaction.user
      @active_bonus_contracts = @user.bonus_contracts.active.order(:created_at)
      @first_active_bonus_contract = @active_bonus_contracts.try(:first)
      @contract_count = @active_bonus_contracts.length
    end

    def distribute_bonus_to_contracts(bonus_amount)
      remaining_balance = bonus_amount
      @active_bonus_contracts.each_with_index do |contract, index|
        bonus = remaining_balance
        remaining_balance -= contract.calculate_remaining_balance.to_f
        last_contract = index == @contract_count - 1
        if last_contract && remaining_balance > 0
          bonus = contract.calculate_remaining_balance.to_f
          chargeback_to_admin(remaining_balance)
        end
        credit_bonus_to(contract, bonus)
        add_bonus_contract_item_to(contract, bonus)
        inactive_contract_pool_point(contract) unless contract.active?
        break if remaining_balance <= 0
      end
    end

    def add_bonus_contract_item_to(contract, bonus)
      contract.bonus_contract_items.create!(financial_transaction: @financial_transaction,
                                            cent_amount: bonus)
    end

    def credit_bonus_to(contract, bonus_amount)
      contract.received_balance = contract.received_balance.to_f + bonus_amount
      contract.remaining_balance = contract.cent_amount - contract.received_balance.to_f
      contract.paid_at = Date.current if contract.remaining_balance.to_f.round == 0
      contract.save!
    end

    def chargeback_to_admin(remaining_balance)
      user = User.find_morenwm_customer_admin
      user.financial_transactions.create!(spreader: @user,
                                          financial_reason: FinancialReason.chargeback_by_contract_limit,
                                          cent_amount: remaining_balance,
                                          moneyflow: :debit)
    end

    def inactive_contract_pool_point(contract)
      order = contract.order
      user = contract.user
      pool_point = user.scores.pool_point_by(order).first
      pool_point.update!(inactive_at: Date.current) if pool_point
    end

  end
end
