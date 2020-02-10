class NodesBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform
    BinaryNode.includes(:user).find_each do |binary_node|
      Bonification::CreatorBinaryBonusService.call(binary_node: binary_node, date: Date.yesterday)
    end
  end

end
