module Backoffice
  class UnilevelController < EntrepreneurController

    before_action :find_unilevel_node_by_hashid
    before_action :ensure_current_node_is_descendant_of_current_user_node

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
      @current_node ||= User.find_by(id: params[:user]).try(:unilevel_node)
    end

    def ensure_current_node_is_descendant_of_current_user_node
      user = @current_node.user
      return if @current_node.descendant_of?(current_user.unilevel_node) || user == current_user
      redirect_to backoffice_unilevel_index_path(user: current_user)
    end

  end
end
