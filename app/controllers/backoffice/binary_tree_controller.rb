module Backoffice
  class BinaryTreeController < BackofficeController

    before_action :can_access_node?, only: :show

    def index
      @node = current_user.binary_node
      render(:show, locals: { node: @node, current_user_node: current_user.binary_node })
    end

    def show
      @node = binary_node
      render(:show, locals: { node: @node, current_user_node: current_user.binary_node })
    end

    private

    def binary_node
      @binary_node ||= BinaryNodeSearchByUserQuery.new(params).call
    end

    def can_access_node?
      return if BinaryNodePolicy.new(current_user.binary_node).can_access_node?(binary_node)
      flash[:error] = I18n.t('errors.cant_access_binary_node')
      redirect_to backoffice_dashboard_index_path
    end

  end
end
