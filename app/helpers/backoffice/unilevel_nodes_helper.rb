module Backoffice
  module UnilevelNodesHelper

    def direct_children(unilevel_nodes)
      first_depth = unilevel_nodes.map(&:ancestry_depth).uniq.min
      unilevel_nodes.select { |n| n.ancestry_depth == first_depth }
    end

    def count_children_by(career, children)
      count = children.count { |child| child.user.current_career == career }
      count.zero? ? '' : count
    end

  end
end
