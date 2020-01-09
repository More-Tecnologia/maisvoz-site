module Backoffice
  module UnilevelNodesHelper

    def count_children_by(career, children)
      children.count { |child| child.user.current_career == career }
    end

  end
end
