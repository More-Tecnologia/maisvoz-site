module Backoffice
  class BinaryTreeController < BackofficeController

    def index
      render(:index, locals: { user_binary_node_id: current_binary_node_id })
    end

    def show
      render json: tree
    end

    def search_by_user
      render json: {
        id: binary_node ? binary_node.id : nil
      }
    end

    private

    def tree
      Multilevel::FetchBinaryTree.new(current_user, BinaryNode.find(params[:id])).call
    end

    def binary_node
      @binary_node ||= BinaryNodeSearchByUserQuery.new(current_user, params[:username]).call
    end

    def current_binary_node_id
      return unless current_user.binary_node
      current_user.binary_node.id
    end

  end
end
