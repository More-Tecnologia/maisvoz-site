module Bonification
  class PropagateBinaryScore

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

      if parent_node.left_child == child_node
        parent_node.increment!(:left_pv, total_score)
        create_pv_history(:left, parent_node.user)
      elsif parent_node.right_child == child_node
        parent_node.increment!(:right_pv, total_score)
        create_pv_history(:right, parent_node.user)
      end
    end

    def create_pv_history(direction, user)
      Bonification::CreatePvHistory.call(direction, user, order, total_score)
    end

    def user_binary_node
      @user_binary_node ||= order.user.binary_node
    end

    def total_score
      @total_score ||= order.order_items.sum { |item| item.quantity * item.product.binary_score }
    end

  end
end
