module Multilevel
  class FetchBinaryTree

    def initialize(user, node)
      @user = user
      @node = node
    end

    def call
      if node_below_user?
        BinaryTreeSerializer.new(node).to_builder
      else
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
