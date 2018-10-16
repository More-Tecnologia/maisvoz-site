class NodesBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform(node_id)
    node = BinaryNode.find(node_id)

    while node.parent.present?
      node = node.parent
      verify_node(node)
    end
  end

  def verify_node(node)
    return if [node.left_pv, node.right_pv].min < 500
    NodeBinaryBonusVerifierWorker.perform_async(node.id)
  end

end
