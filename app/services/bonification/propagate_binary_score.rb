module Bonification
  class PropagateBinaryScore

    def initialize(order)
      @order = order
    end

    def call
      return if user_binary_node.blank? || total_score <= 0
      navigate_tree_to_top
    end

    private

    MAX_UNQUALIFIED_PV = 2000

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
        check_should_reverse_pv(:left_pv, parent_node)
      elsif parent_node.right_child == child_node
        parent_node.increment!(:right_pv, total_score)
        create_pv_history(:right, parent_node.user)
        check_should_reverse_pv(:right_pv, parent_node)
      end
    end

    def create_pv_history(direction, user, score = false)
      score = score.present? ? score : total_score
      Bonification::CreatePvHistory.call(direction, user, order, score)
    end

    def check_should_reverse_pv(leg, node)
      return if node.user.binary_qualified?

      counter_leg = define_counter_leg(leg)
      direction   = leg == :left_pv ? :left : :right

      if node.send(leg) <= node.send(counter_leg) && (node.send(leg) + total_score) > MAX_UNQUALIFIED_PV
        node.decrement!(leg, total_score)
        create_pv_history(direction, node.user, -total_score)
      end
    end

    def user_binary_node
      @user_binary_node ||= order.user.binary_node
    end

    def total_score
      @total_score ||= order.total_score
    end

    def define_counter_leg(leg)
      leg == :left_pv ? :right_pv : :left_pv
    end

  end
end
