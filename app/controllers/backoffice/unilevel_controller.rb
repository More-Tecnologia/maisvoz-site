module Backoffice
  class UnilevelController < EntrepreneurController

    def index
      @current_node = current_user.unilevel_node
      unilevel_nodes = @current_node.subtree
                                    .includes(user: [career_trails: [:career]])
                                    .where.not(username: current_user.username)
                                    .arrange
      @unilevel_nodes = UnilevelNode.sort_by_ancestry(unilevel_nodes)
      children_ancestries = @unilevel_nodes.map { |node| node.ancestry + "/#{node.id}" }
      @unilevel_node_children = UnilevelNode.where(ancestry: children_ancestries)
                                            .index_by(&:ancestry)
    end

  end
end
