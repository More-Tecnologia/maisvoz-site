class NodeBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform(binary_node_id)
    binary_node = BinaryNode.find(binary_node_id)

    Bonification::CreatorBinaryBonusService.call(binary_node)
  end

end
