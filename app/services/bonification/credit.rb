module Bonification
  class Credit

    prepend SimpleCommand

    def initialize(user:, order:, bonus_amount:, kind:, description:)
      @user         = user
      @order        = order
      @bonus_amount = bonus_amount
      @kind         = kind
      @description  = description
    end

    def call
      check_user
      user.with_lock do
        update_user_balance
        create_financial_entry
      end
    end

    private

    attr_reader :user, :order, :bonus_amount, :kind, :description

    def check_user
      unless user.present? && user.active?
        @user = master_user
        @description += ' [Estorno de bônus para o sistema]'
      end
    end

    def update_user_balance
      user.available_balance += half_bonus
      user.blocked_balance   += half_bonus
      user.save!
    end

    def create_financial_entry
      FinancialEntry.new.tap do |bonus|
        bonus.user        = user
        bonus.description = description
        bonus.kind        = kind
        bonus.amount      = bonus_amount
        bonus.balance     = user.balance + bonus_amount.to_f
        bonus.order       = order
        bonus.save!
      end
    end

    def half_bonus
      @half_bonus ||= bonus_amount / 2
    end

    def master_user
      @master_user ||= User.find_by(username: master_username)
    end

    def master_username
      ENV['MASTER_FINANCIAL_ACCOUNT']
    end

  end
end
