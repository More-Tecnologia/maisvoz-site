#
# É executado quando o cliente se qualifica no binário
# Verificar se qualificou o binário dentro de 7 dias e pagar 7,5% do bônus binário
# gerado pelos ativos
#
module Bonification
  class CreditFlexBonus

    # 7,5% dos PVs
    PERCENTAGE = 0.075

    def initialize(user)
      @user = user
    end

    def call
      return unless user.active?
      return unless user.empreendedor? && qualified_in_less_than_7_days? && bonus_amount > 0

      ActiveRecord::Base.transaction do
        credit_bonus

        if indication_bonus.count == 2
          update_user_balance
          create_system_financial_log
        elsif indication_bonus.count < 2
          reverse_bonus('Bônus de indicação direta insuficiente.')
        else
          reverse_bonus
        end
      end
    end

    private

    attr_reader :user

    def qualified_in_less_than_7_days?
      (Time.zone.today - (user.active_until - 180.days)).to_i <= 7
    end

    def credit_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus flex. Bônus de #{h.number_to_currency bonus_amount}, faturas: #{indication_bonus.collect(&:id).join(', ')}"
        bonus.kind        = FinancialEntry.kinds[:flex_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount
        bonus.save!
      end
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus flex. Bônus de #{h.number_to_currency bonus_amount}, usuário ID: #{user.id}, username: #{user.username}, faturas: #{indication_bonus.collect(&:id).join(', ')}"
        log.kind        = SystemFinancialLog.kinds[:flex_bonus]
        log.amount      = -bonus_amount
        log.save!
      end
    end

    def reverse_bonus(reason)
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "[Estorno] Bônus flex. #{reason} Bônus de #{h.number_to_currency bonus_amount}. Faturas: #{indication_bonus.collect(&:id).join(', ')}"
        bonus.kind        = FinancialEntry.kinds[:reverse_bonus]
        bonus.amount      = -bonus_amount
        bonus.balance     = user.balance
        bonus.save!
      end
    end

    def update_user_balance
      user.increment!(:available_balance_cents, (bonus_amount / 2) * 100)
      user.increment!(:blocked_balance_cents, (bonus_amount / 2) * 100)
    end

    def indication_bonus
      @indication_bonus ||= LastTwoDirectIndicationBonusQuery.new(user).call
    end

    def bonus_amount
      if indication_bonus.count == 2
        @bonus_amount ||= (indication_bonus.first.amount.to_f + indication_bonus.second.amount.to_f) * PERCENTAGE
      else
        @bonus_amount ||= 0
      end
    end

    def h
      ActionController::Base.helpers
    end

  end
end
