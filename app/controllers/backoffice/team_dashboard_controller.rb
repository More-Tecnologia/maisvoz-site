# frozen_string_literal: true

module Backoffice
  class TeamDashboardController < EntrepreneurController

    before_action :current_node, only: :index

    def index
      @unilevel_nodes = @current_node.subtree
                                     .from_depth(@current_node.depth)
                                     .to_depth(unilevel_max_depth)
                                     .includes(user: %i[sponsor career])
                                     .where.not(id: @current_node.user.id)
    end

    private

    def ensure_no_admin_user
      if user_signed_in? && (current_user.admin? || current_user.financeiro?)
        redirect_to backoffice_admin_dashboard_index_path
      end
    end

    def current_node
      @current_node ||= current_user.try(:unilevel_node)
    end

    def unilevel_max_depth
      @current_node.depth + ENV['UNILEVEL_MAX_GENERATION'].to_i
    end

  end
end
