class NodeActiveUntilTodayVerifierWorker

  include Sidekiq::Worker

  def perform(node_id, date)
    node = BinaryNode.find(node_id)

    Multilevel::VerifyNodeStillActive.new(node, date).call
  end

end
