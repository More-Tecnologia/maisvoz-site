class BinaryNodeSearchByUserQuery

  def initialize(parent_user, username)
    @parent_user = parent_user
    @username = username
  end

  def call
    return unless node_below_user?
    binary_node
  end

  private

  attr_reader :parent_user, :username

  def node_below_user?
    user_node = parent_user.binary_node
    child_node = binary_node
    while child_node != nil
      return true if user_node == child_node
      child_node = child_node.parent
    end
    false
  end

  def binary_node
    @binary_node ||= BinaryNode.find_by(user: user)
  end

  def user
    @user ||= User.where(username: username).first
  end

end
