module Bonification
  class CreditBinaryBonus

    PV_CYCLE = 500

    def initialize(binary_node)
      @binary_node = binary_node
      @user        = binary_node.user
    end

    def call
      return unless user.binary_qualified?
      return if user.career_kind.blank?
      return if min_pv < PV_CYCLE
      ActiveRecord::Base.transaction do
        if can_receive_bonus?
          credit_binary_bonus
          binary_node
        elsif !user.active?
          reverse_binary_bonus('Inatividade', binary_bonus)
        elsif monthly_limit_reached? && binary_bonus > 0
          reverse_binary_bonus("Limite mensal atingido", binary_bonus)
          debit_pv_from_both_legs
        elsif gross_bonus + bonus_received_this_week > weekly_limit
          reverse_binary_bonus("Limite semanal de #{h.number_to_currency weekly_limit} atingido para a carreira #{user.career_kind.upcase}", gross_bonus)
          debit_pv_from_both_legs
        end
      end
    end

    private

    attr_reader :binary_node, :binary_bonus_entry

    delegate :user, to: :binary_node

    def credit_binary_bonus
      binary_node.with_lock do
        create_bonus
        reverse_the_excedent
        update_user_balance
        debit_pv_from_both_legs
        create_system_financial_log
      end
    end

    def create_bonus
      @binary_bonus_entry ||= FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus binário sobre #{pv_to_be_credited} PVs"
        bonus.kind        = FinancialEntry.kinds[:binary_bonus]
        bonus.amount      = gross_bonus
        bonus.balance     = user.balance + gross_bonus
        bonus.save!
      end
    end

    def reverse_the_excedent
      return unless gross_bonus > binary_bonus

      amount = gross_bonus - binary_bonus

      FinancialEntry.new.tap do |entry|
        entry.user        = user
        entry.description = "[Estorno] Bônus binário de #{h.number_to_currency amount}. Motivo: Limite semanal de #{h.number_to_currency weekly_limit} atingido para a carreira #{user.career_kind.upcase}"
        entry.amount      = -amount
        entry.balance     = (user.balance + gross_bonus) - amount
        entry.kind        = FinancialEntry.kinds[:reverse_binary_bonus]
        entry.save!
      end
    end

    def update_user_balance
      user.increment!(:available_balance_cents, (binary_bonus / 2) * 100)
      user.increment!(:blocked_balance_cents, (binary_bonus / 2) * 100)
    end

    def debit_pv_from_both_legs
      Bonification::CreatePvHistory.call(:left, user, nil, -pv_to_be_credited)
      Bonification::CreatePvHistory.call(:right, user, nil, -pv_to_be_credited)
      binary_node.decrement!(:left_pv, pv_to_be_credited)
      binary_node.decrement!(:right_pv, pv_to_be_credited)
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus binário ID: #{binary_bonus_entry.id} de #{h.number_to_currency binary_bonus}"
        log.amount      = -binary_bonus
        log.kind        = SystemFinancialLog.kinds[:binary_bonus]
        log.save!
      end
    end

    def reverse_binary_bonus(reason, amount)
      ActiveRecord::Base.transaction do
        FinancialEntry.new.tap do |bonus|
          bonus.user        = user
          bonus.description = "Bônus binário de #{h.number_to_currency amount}"
          bonus.kind        = FinancialEntry.kinds[:binary_bonus]
          bonus.amount      = amount
          bonus.balance     = user.balance + amount
          bonus.save!
        end
        FinancialEntry.new.tap do |entry|
          entry.user        = user
          entry.description = "[Estorno] Bônus binário de #{h.number_to_currency amount}. Motivo: #{reason}"
          entry.amount      = -amount
          entry.balance     = user.balance
          entry.kind        = FinancialEntry.kinds[:reverse_binary_bonus]
          entry.save!
        end
      end
    end

    def can_receive_bonus?
      user.active? && binary_bonus > 0 && !monthly_limit_reached?
    end

    def exceeded_weekly_limit?
      gross_bonus + bonus_received_this_week > weekly_limit
    end

    def binary_bonus
      @binary_bonus ||= exceeded_weekly_limit? ? weekly_limit - bonus_received_this_week : gross_bonus
    end

    def gross_bonus
      @gross_bonus ||= (pv_to_be_credited * binary_percent).to_f
    end

    def binary_percent
      user.product.binary_bonus
    end

    def bonus_received_this_week
      @bonus_received_this_week ||= WeeklyBinaryBonusReceivedQuery.new(user).call
    end

    def weekly_limit
      @weekly_limit ||= CalculateBinaryBonusLimit.new(user).call
    end

    def pv_to_be_credited
      @pv_to_be_credited ||= min_pv.div(PV_CYCLE) * PV_CYCLE
    end

    def min_pv
      @min_pv ||= [binary_node.left_pv, binary_node.right_pv].min
    end

    def monthly_limit_reached?
      @monthly_limit_reached ||= FinancialEntryPolicy.new(user)
                                                     .monthly_limit_reached?
    end

    def h
      ActionController::Base.helpers
    end

  end
end
