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
        debit_binary_score(current_node)
        current_node = current_node.parent
      end
    end

    def debit_binary_score(child_node)
      parent_node = child_node.parent

      order_items.each do |item|
        quantity, product = *item
        score = quantity * product.binary_score

        if parent_node.left_child == child_node
          parent_node.update!(left_pv: parent_node.left_pv + score)
        elsif parent_node.right_child == child_node
          parent_node.update!(right_pv: parent_node.right_pv + score)
        end
      end
    end

    def user_binary_node
      @user_binary_node ||= order.user.binary_node
    end

    def order_items
      @order_items ||= order.order_items.map { |item| [item.quantity, item.product] }
    end

  end
end
