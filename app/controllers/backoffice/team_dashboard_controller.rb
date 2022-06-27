# frozen_string_literal: true

module Backoffice
  class TeamDashboardController < EntrepreneurController
    before_action :user, only: :index
    before_action :current_node, only: :index

    def index
      @unilevel_nodes = @current_node.subtree
                                     .from_depth(@current_node.depth)
                                     .includes(user: %i[sponsor career])
                                     .where.not(id: @current_node.user.id)
                                     .uniq
      @unilevel_nodes = @unilevel_nodes.joins(:user).where("users.name LIKE :search OR users.username LIKE :search", search: "%#{params[:q]}%") if params[:q]
    end

    private

    def ensure_no_admin_user
      if user_signed_in? && (@user.admin? || @user.financeiro?)
        redirect_to backoffice_admin_dashboard_index_path
      end
    end

    def user
      @user = params[:user].present? ? User.find(params[:user]) : current_user
    end

    def current_node
      @current_node ||= @user.try(:unilevel_node)
    end

    def unilevel_max_depth
      @current_node.depth + ENV['UNILEVEL_MAX_GENERATION'].to_i
    end

  end
end
