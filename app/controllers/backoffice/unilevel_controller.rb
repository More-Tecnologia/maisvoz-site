module Backoffice
  class UnilevelController < EntrepreneurController

    before_action :find_unilevel_node_by_hashid

    def index
      @unilevel_nodes = @current_node.subtree
                                     .from_depth(@current_node.depth)
                                     .to_depth(unilevel_max_depth)
                                     .includes(user: [:sponsor])
                                     .where.not(username: @current_node.user.username)
    end

    private

    def unilevel_max_depth
      @current_node.depth + ENV['UNILEVEL_MAX_GENERATION'].to_i
    end

    def find_unilevel_node_by_hashid
      @current_node ||= User.find_by_hashid(params[:user]).try(:unilevel_node)
    end

  end
end
