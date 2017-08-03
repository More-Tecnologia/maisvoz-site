module Bonus
  class CreditBinaryBonus

    PV_CYCLE = 1000

    prepend SimpleCommand

    def initialize(binary_node)
      @binary_node = binary_node
    end

    def call
      if min_pv < PV_CYCLE
        errors.add(:binary_node, 'insufficient bonus')
      elsif credit_binary_bonus
        return binary_node
      end
      nil
    end

    private

    attr_reader :binary_node

    def credit_binary_bonus
      ActiveRecord::Base.transaction do
        account.lock!
        binary_node.lock!

        create_financial_entry
        update_account_balance
        debit_pv_from_both_legs
        create_pv_history
      end
    end

    def create_financial_entry
      financial_entry = FinancialEntry.new
      financial_entry.kind = FinancialEntry.kinds[:binary_bonus]
      financial_entry.to_id = account.id
      financial_entry.amount = binary_bonus
      financial_entry.save!
    end

    def update_account_balance
      account.update!(blocked_balance: account.blocked_balance.to_f + binary_bonus)
    end

    def debit_pv_from_both_legs
      binary_node.update!(
        left_pv: binary_node.left_pv - pv_to_be_credited,
        right_pv: binary_node.right_pv - pv_to_be_credited
      )
    end

    def create_pv_history
      Bonus::CreatePvHistory.call(:left, binary_node.user, nil, -pv_to_be_credited)
      Bonus::CreatePvHistory.call(:right, binary_node.user, nil, -pv_to_be_credited)
    end

    def binary_bonus
      @binary_bonus ||= (pv_to_be_credited * (career.binary_percentage / 100.0)).to_f
    end

    def pv_to_be_credited
      @pv_to_be_credited ||= min_pv.div(PV_CYCLE) * PV_CYCLE
    end

    def min_pv
      @min_pv ||= [binary_node.left_pv, binary_node.right_pv].min
    end

    def account
      @account ||= binary_node.user.account
    end

    def career
      binary_node.career
    end

  end
end
