class NodesBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform(node_id)
    node = BinaryNode.find(node_id)
    ancestors = node.reached_minimum_score_paid_ancestors
    ancestors.each do |ancestor|
      NodeBinaryBonusVerifierWorker.perform_async(ancestor.id)
    end
  end

  def verify_node(node)
    return if [node.left_pv, node.right_pv].min < 500
    NodeBinaryBonusVerifierWorker.perform_async(node.id)
  end

end
