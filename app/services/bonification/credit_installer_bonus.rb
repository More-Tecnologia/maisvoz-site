module Bonification
  class CreditInstallerBonus

    def initialize(product_setup)
      @product_setup = product_setup
      @user          = product_setup.installer
    end

    def call
      return unless user.instalador?

      ActiveRecord::Base.transaction do
        credit_bonus

        update_user_balance
        create_system_financial_log
      end
    end

    private

    attr_reader :product_setup, :user

    def credit_bonus
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = "Bônus de instalação no valor de #{h.number_to_currency bonus_amount}. Instalação ##{product_setup.hashid}"
        bonus.kind        = FinancialEntry.kinds[:installer_bonus]
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount
        bonus.save!
      end
    end

    def create_system_financial_log
      SystemFinancialLog.new.tap do |log|
        log.description = "Bônus de instalação do usuário #{user.username}. Bônus de #{h.number_to_currency bonus_amount}, fatura ID: #{product_setup.hashid}"
        log.kind        = SystemFinancialLog.kinds[:installer_bonus]
        log.amount      = -bonus_amount
        log.save!
      end
    end

    def update_user_balance
      user.increment!(:available_balance_cents, bonus_amount * 100)
    end

    def bonus_amount
      @bonus_amount ||= product_setup.product.bonus_1
    end

    def h
      ActionController::Base.helpers
    end

  end
end
