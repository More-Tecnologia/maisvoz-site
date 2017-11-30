module Multilevel
  class QualifyUser

    def initialize(user)
      @user = user
    end

    def call
      return if binary_node.blank?
      binary_node.update!(qualified: qualified?)
    end

    private

    attr_reader :user

    def qualified?
      left_active? && right_active?
    end

    def left_active?
      user.sponsored.left.joins(:binary_node).where('binary_nodes.active = true').any?
    end

    def right_active?
      user.sponsored.right.joins(:binary_node).where('binary_nodes.active = true').any?
    end

    def binary_node
      @binary_node ||= user.binary_node
    end

  end
end
