module Bonification
  class CreditBinaryBonus

    PV_CYCLE = 1000

    def initialize(binary_node)
      @binary_node = binary_node
    end

    def call
      return unless user.can_receive_commission?
      if min_pv < PV_CYCLE
        raise 'insufficient bonus'
      elsif credit_binary_bonus
        binary_node
      end
    end

    private

    attr_reader :binary_node

    delegate :user, to: :binary_node

    def credit_binary_bonus
      ActiveRecord::Base.transaction do
        account.lock!
        binary_node.lock!

        create_bonus
        update_account_balance
        debit_pv_from_both_legs
        create_pv_history
      end
    end

    def create_bonus
      Bonus.new.tap do |bonus|
        bonus.user   = user
        bonus.kind   = Bonus.kinds[:binary]
        bonus.amount = binary_bonus
        bonus.save!
      end
    end

    def update_account_balance
      account.increment(blocked_balance: binary_bonus)
    end

    def debit_pv_from_both_legs
      binary_node.decrement(:left_pv, pv_to_be_credited)
      binary_node.decrement(:right_pv, pv_to_be_credited)
    end

    def create_pv_history
      Bonification::CreatePvHistory.call(:left, user, nil, -pv_to_be_credited)
      Bonification::CreatePvHistory.call(:right, user, nil, -pv_to_be_credited)
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

    def account
      @account ||= user.account
    end

    def career
      binary_node.career
    end

  end
end
