class BinaryTreeSerializer

  def initialize(root_node, max_levels = 3)
    @root_node = root_node
    @max_levels = max_levels
  end

  def to_builder
    {
      root: build_tree
    }.as_json
  end

  private

  attr_reader :root_node, :max_levels

  def build_tree
    tree = create_tree
    tree = fill_tree(tree, root_node)
    tree
  end

  def create_tree(counter = 0)
    return more_node if counter >= max_levels

    {
      image: h.asset_path('packages/default.png'),
      children: [
        create_tree(counter + 1),
        create_tree(counter + 1)
      ]
    }
  end

  def fill_tree(tree_node, node, counter = 0)
    return tree_node if counter >= max_levels
    return tree_node if node.nil?

    package_img = node.career.present? ? node.career.thumbnail.url : h.asset_path('packages/pkg.png')

    {
      image: package_img,
      data: node_data(node),
      HTMLid: node.id,
      children:
      [
        fill_tree(tree_node[:children][0], node.left_child, counter + 1),
        fill_tree(tree_node[:children][1], node.right_child, counter + 1)
      ]
    }
  end

  def more_node
    @more_node ||= {
      image: h.asset_path('packages/more.png'),
      end: true
    }
  end

  def node_data(node)
    {
      username: node.user.username,
      sponsor: node.sponsored_by.try(:username),
      career: node.career.try(:name),
      left_pv: node.left_pv,
      right_pv: node.right_pv
    }
  end

  def h
    ApplicationController.helpers
  end

end
