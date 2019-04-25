module Bonification
  class CreditExecutiveSaleBonus

    # 20% dos PVs
    PERCENTAGE = 0.2

    def initialize(order)
      @order = order
    end

    def call
      return if bonus_amount <= 0

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

    attr_reader :order

    delegate :user, to: :order

    def credit_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = sponsor
        bonus.description = "Bônus de venda direta da compra do usuário #{user.username}. Bônus de #{h.number_to_currency bonus_amount}"
        bonus.kind        = FinancialEntry.kinds[:executive_sale_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = sponsor.balance + bonus_amount
        bonus.order       = order
        bonus.save!
      end
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus de venda direta da compra do usuário #{user.username}. Bônus de #{h.number_to_currency bonus_amount}, fatura ID: #{order.hashid}"
        log.kind        = SystemFinancialLog.kinds[:executive_sale_bonus]
        log.amount      = -bonus_amount
        log.order       = order
        log.save!
      end
    end

    def reverse_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = sponsor
        bonus.description = "[Estorno] Bônus de venda direta da compra do usuário #{user.username}. Bônus de #{h.number_to_currency bonus_amount}"
        bonus.kind        = FinancialEntry.kinds[:reverse_bonus]
        bonus.amount      = -bonus_amount
        bonus.balance     = sponsor.balance
        bonus.order       = order
        bonus.save!
      end
    end

    def update_user_balance
      sponsor.increment!(:available_balance_cents, (bonus_amount / 2) * 100)
      sponsor.increment!(:blocked_balance_cents, (bonus_amount / 2) * 100)
    end

    def can_receive_bonus?
      sponsor.active? && sponsor.empreendedor?
    end

    def sponsor
      @sponsor ||= user.sponsor
    end

    def bonus_amount
      @bonus_amount ||= order.pvv_score * PERCENTAGE
    end

    def h
      ActionController::Base.helpers
    end

  end
end
