module Backoffice
  class BinaryTreeController < BackofficeController

    def index
      render(:index, locals: { nodes: nodes })
    end

    def show
      nodes = Multilevel::FetchBinaryTree.new(current_user, BinaryNode.find(params[:id])).call
      render json: nodes
    end

    private

    def nodes
      @nodes ||= BinaryTreeSerializer.new(current_user.binary_node).to_builder
    end

  end
end
