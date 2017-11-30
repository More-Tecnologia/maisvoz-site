module Bonification
  class CreatePvHistory

    prepend SimpleCommand

    def initialize(direction, user, order, score)
      @direction = direction
      @user = user
      @order = order
      @score = score
    end

    def call
      PvHistory.create!(
        direction: direction,
        user: user,
        order: order,
        amount: score,
        balance: final_balance
      )
    end

    private

    attr_reader :direction, :user, :order, :score

    def final_balance
      last_balance + score
    end

    def last_balance
      return 0 if last_pv_history.blank?
      last_pv_history.balance.to_f
    end

    def last_pv_history
      # TODO otimizar aqui buscando o pv pelo binary_node
      @pv_history ||= PvHistory.where(
        direction: direction,
        user: user
      ).order(created_at: :desc).first
    end

  end
end
