class BinaryNodePolicy

  def initialize(binary_node)
    @binary_node = binary_node
  end

  def can_access_node?(node)
    while node.present?
      return true if node == binary_node
      node = node.parent
    end
    false
  end

  private

  attr_reader :binary_node

end
