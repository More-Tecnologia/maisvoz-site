class VerifyBinaryBonusWorker
  include Sidekiq::Worker

  def perform(binary_node_id)
    binary_node = BinaryNode.find(binary_node_id)

    Bonus::CreditBinaryBonus.call(binary_node)
  end

end
