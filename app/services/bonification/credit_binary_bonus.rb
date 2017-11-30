module Bonification
  class CreditBinaryBonus

    PV_CYCLE = 1000

    def initialize(binary_node)
      @binary_node = binary_node
      @user        = binary_node.user
    end

    def call
      if user.can_receive_commission?
        if min_pv < PV_CYCLE
          raise 'insufficient bonus'
        elsif credit_binary_bonus
          binary_node
        end
      else
        reverse_binary_bonus
      end
    end

    private

    attr_reader :binary_node, :binary_bonus_entry

    delegate :user, to: :binary_node

    def credit_binary_bonus
      ActiveRecord::Base.transaction do
        binary_node.lock!

        create_bonus
        update_user_balance
        debit_pv_from_both_legs
        create_pv_history
        create_system_financial_log
      end
    end

    def create_bonus
      @binary_bonus_entry ||= FinancialEntry.new.tap do |bonus|
        bonus.user          = user
        bonus.description   = "Bônus binário sobre #{pv_to_be_credited} PVs"
        bonus.kind          = FinancialEntry.kinds[:binary_bonus]
        bonus.amount        = binary_bonus
        bonus.balance_cents = user.available_balance_cents + binary_bonus
        bonus.save!
      end
    end

    def update_user_balance
      user.increment!(blocked_balance_cents: binary_bonus * 100)
    end

    def debit_pv_from_both_legs
      binary_node.decrement!(:left_pv, pv_to_be_credited)
      binary_node.decrement!(:right_pv, pv_to_be_credited)
    end

    def create_pv_history
      Bonification::CreatePvHistory.call(:left, user, nil, -pv_to_be_credited)
      Bonification::CreatePvHistory.call(:right, user, nil, -pv_to_be_credited)
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description  = "Pagamento de bônus binário ID: #{binary_bonus_entry.id} de $#{binary_bonus}"
        log.amount_cents = -binary_bonus
        log.kind         = SystemFinancialLog.kinds[:binary_bonus]
        log.save!
      end
    end

    def reverse_binary_bonus
      FinancialEntry.new.tap do |entry|
        entry.user          = user
        entry.description   = "Estorno de bônus binário de $#{binary_bonus} por inatividade"
        entry.amount_cents  = 0
        entry.balance_cents = user.available_balance_cents
        entry.kind          = FinancialEntry.kinds[:reverse_bonus]
        entry.save!
      end
    end

    def binary_bonus
      @binary_bonus ||= (pv_to_be_credited * (career.binary_percentage / 100.0)).to_f
    end

    def pv_to_be_credited
      if user.bought_product?
        @pv_to_be_credited ||= (min_pv.div(PV_CYCLE) * PV_CYCLE) / 2.0
      else
        @pv_to_be_credited ||= min_pv.div(PV_CYCLE) * PV_CYCLE
      end
    end

    def min_pv
      @min_pv ||= [binary_node.left_pv, binary_node.right_pv].min
    end

    def career
      binary_node.career
    end

  end
end
