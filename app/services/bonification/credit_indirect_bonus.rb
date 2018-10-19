module Bonification
  class CreditIndirectBonus

    BONUS = 0.04
    MAX_LEVEL = 6

    def initialize(order)
      @order = order
      @buyer = order.user
    end

    def call
      return if buyer.sponsor.blank? || order.adhesion_product.blank?
      ActiveRecord::Base.transaction do
        distribute_bonus
      end
    end

    private

    attr_reader :order, :buyer

    def distribute_bonus
      level = 2
      receiver = buyer.sponsor.sponsor
      while receiver.present? && level <= MAX_LEVEL
        credit_bonus(receiver, level) if receiver.active?
        reverse_bonus(receiver, level) if !receiver.active?
        level += 1
        receiver = receiver.sponsor
      end
    end

    def credit_bonus(user, level)
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus de indicação indireta no valor de #{h.number_to_currency bonus_amount}. Geração #{level}˚."
        bonus.kind        = FinancialEntry.kinds[:indirect_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount
        bonus.order       = order
        bonus.save!
      end
      user.increment!(:available_balance_cents, (bonus_amount / 2) * 100)
      user.increment!(:blocked_balance_cents, (bonus_amount / 2) * 100)

      create_system_financial_log(user, level)
    end

    def create_system_financial_log(user, level)
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus indicação indireta. Bônus de #{h.number_to_currency bonus_amount}, usuário ID: #{user.id}, username: #{user.username}, geração #{level}˚."
        log.kind        = SystemFinancialLog.kinds[:indirect_bonus]
        log.amount      = -bonus_amount
        log.save!
      end
    end

    def reverse_bonus(user, level)
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus de indicação indireta no valor de #{h.number_to_currency bonus_amount}. Geração #{level}˚."
        bonus.kind        = FinancialEntry.kinds[:indirect_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount
        bonus.save!
      end
      FinancialEntry.new.tap do |entry|
        entry.user        = user
        entry.description = "[Estorno] Bônus indicação indireta. Bônus de #{h.number_to_currency bonus_amount}. Geração #{level}˚."
        entry.kind        = FinancialEntry.kinds[:reverse_bonus]
        entry.amount      = -bonus_amount
        entry.balance     = user.balance
        entry.save!
      end
    end

    def bonus_amount
      @bonus_amount ||= order.pvg_score * BONUS
    end

    def h
      ActionController::Base.helpers
    end

  end
end
