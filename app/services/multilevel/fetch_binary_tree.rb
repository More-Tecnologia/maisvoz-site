module Multilevel
  class FetchBinaryTree

    def initialize(user, node)
      @user = user
      @node = node
    end

    def call
      if node_below_user?
        {
          nodes: BinaryTreeSerializer.new(node).to_builder,
          parent_id: node.parent_id
        }
      end
    end

    private

    attr_reader :user, :node

    def node_below_user?
      user_node = user.binary_node
      child_node = node
      while child_node != nil
        return true if user_node == child_node
        child_node = child_node.parent
      end
      false
    end

  end
end
