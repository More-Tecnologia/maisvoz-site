class NodesBinaryBonusVerifierWorker

  include Sidekiq::Worker

  def perform
    BinaryNode.includes(:user).find_each do |binary_node|
      begin
        ActiveRecord::Base.transaction do
          Bonification::CreatorBinaryBonusService.call(binary_node: binary_node)
        end
      rescue Exception => error
        puts "Binary Bonus Error For #{binary_node.try(:user).try(:username)}: #{error.message}"
        puts error.backtrace
      end
    end
  end

end
