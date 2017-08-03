module Bonus
  class PropagateBinaryScore

    prepend SimpleCommand

    def initialize(order)
      @order = order
    end

    def call
      return if user_binary_node.blank?
      navigate_tree_to_top
    end

    private

    attr_reader :order

    def navigate_tree_to_top
      current_node = user_binary_node
      while current_node.parent.present?
        credit_binary_score(current_node)
        current_node = current_node.parent
      end
    end

    def credit_binary_score(child_node)
      parent_node = child_node.parent
      direction = nil

      if parent_node.left_child == child_node
        parent_node.update!(left_pv: parent_node.left_pv + total_score)
        direction = :left
      elsif parent_node.right_child == child_node
        parent_node.update!(right_pv: parent_node.right_pv + total_score)
        direction = :right
      end

      create_pv_history(direction, parent_node.user, total_score)
      verify_binary_bonus(parent_node)
    end

    def create_pv_history(direction, user, score)
      Bonus::CreatePvHistory.call(direction, user, order, score)
    end

    def verify_binary_bonus(node)
      return if [node.left_pv, node.right_pv].min < 1000
      VerifyBinaryBonusWorker.perform_async(node.id)
    end

    def user_binary_node
      @user_binary_node ||= order.user.binary_node
    end

    def total_score
      @total_score ||= order.order_items.sum { |item| item.quantity * item.product.binary_score }
    end

  end
end
