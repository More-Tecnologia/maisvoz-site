class NodeBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform(binary_node_id)
    binary_node = BinaryNode.find(binary_node_id)
    Bonus::CreditBinaryBonus.new(binary_node).call
  end

end
