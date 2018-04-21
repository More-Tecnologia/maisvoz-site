module Bonification
  class CreditSocialLeaderBonus

    PERCENTAGE = 0.02
    MAX_LIMIT = 500_000

    def initialize(user, ref_date)
      @user = user
      @ref_date = ref_date
    end

    def call
      return unless user.empreendedor? && !gross_amount.zero?

      ActiveRecord::Base.transaction do
        credit_bonus

        if can_receive_bonus? && gross_amount <= MAX_LIMIT
          create_system_financial_log(gross_amount)
          update_user_balance(gross_amount)
        elsif can_receive_bonus? && gross_amount > MAX_LIMIT
          reverse_bonus_by_monthly_limit
          update_user_balance(MAX_LIMIT)
          create_system_financial_log(MAX_LIMIT)
        else
          reverse_bonus
        end
      end
    end

    private

    attr_reader :user, :ref_date

    def credit_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus social líder. Bônus de #{h.number_to_currency(gross_amount)} sobre #{h.number_with_delimiter(total_pv_activity)} PVA/PVG"
        bonus.kind        = FinancialEntry.kinds[:social_leader_bonus]
        bonus.amount      = gross_amount
        bonus.balance     = user.balance + gross_amount
        bonus.save!
      end
    end

    def update_user_balance(amount)
      user.increment!(:available_balance_cents, (amount / 2) * 100)
      user.increment!(:blocked_balance_cents, (amount / 2) * 100)
    end

    def create_system_financial_log(amount)
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus social líder. Bônus de #{h.number_to_currency(amount)}, usuário ID: #{user.id}, username: #{user.username}"
        log.kind        = SystemFinancialLog.kinds[:social_leader_bonus]
        log.amount      = -amount
        log.save!
      end
    end

    def reverse_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "[Estorno] Bônus social líder. Bônus de #{h.number_to_currency(gross_amount)}"
        bonus.kind        = FinancialEntry.kinds[:reverse_bonus]
        bonus.amount      = -gross_amount
        bonus.balance     = user.balance
        bonus.save!
      end
    end

    def reverse_bonus_by_monthly_limit
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "[Estorno] Bônus social líder. Motivo: Limite mensal atingido"
        bonus.kind        = FinancialEntry.kinds[:reverse_bonus]
        bonus.amount      = -(gross_amount - MAX_LIMIT)
        bonus.balance     = user.balance + MAX_LIMIT
        bonus.save!
      end
    end

    def gross_amount
      @gross_amount ||= total_pv_activity * PERCENTAGE
    end

    def total_pv_activity
      @total_pv_activity ||= generation_users.sum { |u| u.month_pva(ref_date) }
    end

    def generation_users
      @generation_users ||= Multilevel::FetchUnilevelLeaderGenerations.new(user).call
    end

    def can_receive_bonus?
      user.active? && user.binary_qualified? && (
        user.emerald? || user.diamond? || user.white_diamond? ||
        user.blue_diamond? || user.black_diamond? || user.chairman? ||
        user.chairman_two_star? || user.chairman_three_star?
      )
    end

    def h
      ActionController::Base.helpers
    end

  end
end
