module Backoffice
  class UnilevelController < EntrepreneurController

    def index
      @current_node = current_user.unilevel_node
      @unilevel_nodes = @current_node.subtree
                                    .from_depth(@current_node.depth)
                                    .to_depth(unilevel_max_depth)
                                    .includes(user: [career_trails: [:career]])
                                    .where.not(username: current_user.username)
                                    .group_by(&:ancestry_depth)
    end

    private

    def unilevel_max_depth
      @current_node.depth + ENV['UNILEVEL_MAX_GENERATION'].to_i
    end

  end
end
