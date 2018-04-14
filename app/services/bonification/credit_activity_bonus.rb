module Bonification
  class CreditActivityBonus

    def initialize(user)
      @user = user
    end

    def call
      return unless user.empreendedor? && bonus_amount > 0

      ActiveRecord::Base.transaction do
        credit_bonus

        if can_receive_bonus?
          update_user_balance
          create_system_financial_log
        else
          reverse_bonus
        end
      end
    end

    private

    attr_reader :user

    def credit_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus de atividade. Bônus de #{h.number_to_currency(bonus_amount)}. Referente aos PVA/PVG a partir de #{30.days.ago.to_date} até #{Time.zone.today}"
        bonus.kind        = FinancialEntry.kinds[:activity_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount
        bonus.save!
      end
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus de atividade. Bônus de #{h.number_to_currency(bonus_amount)}"
        log.kind        = SystemFinancialLog.kinds[:activity_bonus]
        log.amount      = -bonus_amount
        log.save!
      end
    end

    def reverse_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "[Estorno] Bônus de atividade. Bônus de #{h.number_to_currency(bonus_amount)}. Motivo: Inatividade."
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

    def bonus_amount
      @bonus_amount ||= if financial_entry_policy.monthly_limit_reached?(gross_amount)
                          financial_entry_policy.amount_left
                        else
                          gross_amount
                        end
    end

    def gross_amount
      @gross_amount ||= total_pv_activity * bonus_range
    end

    def bonus_range
      CalculateUserActivityBonusRange.new(user).call
    end

    def total_pv_activity
      user.pv_activity_histories.where('height <= 6').sum(:amount)
    end

    def can_receive_bonus?
      user.active?
    end

    def financial_entry_policy
      @monthly_limit_reached ||= FinancialEntryPolicy.new(user)
    end

    def h
      ActionController::Base.helpers
    end

  end
end
