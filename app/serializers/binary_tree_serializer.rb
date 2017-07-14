class BinaryTreeSerializer

  def initialize(root_node, max_levels = 3)
    @root_node = root_node
    @max_levels = max_levels
  end

  def to_builder
    {
      root: node(root_node, 0)
    }.to_json
  end

  private

  attr_reader :root_node, :max_levels

  def node(node, counter)
    return more_node if counter >= max_levels
    return empty_node if node.nil?

    counter += 1

    {
      image: h.asset_path('packages/pkg.png'),
      data: node_data(node),
      HTMLid: node.id,
      children:
      [
        node(node.left_child, counter),
        node(node.right_child, counter)
      ]
    }
  end

  def empty_node
    @empty_node ||= {
      image: h.asset_path('packages/default.png')
    }
  end

  def more_node
    @more_node ||= {
      image: h.asset_path('packages/more.png')
    }
  end

  def node_data(node)
    {
      username: node.user.username,
      sponsor: node.sponsored_by.try(:username)
    }
  end

  def h
    ApplicationController.helpers
  end

end
