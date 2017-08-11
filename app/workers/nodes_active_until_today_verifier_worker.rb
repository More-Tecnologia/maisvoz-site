class NodesActiveUntilTodayVerifierWorker

  include Sidekiq::Worker

  def perform
    today = Time.zone.today

    NodesActiveUntilTodayQuery.new(today).find_each do |node|
      NodeActiveUntilTodayVerifierWorker.perform_async(node.id, today)
    end
  end

end
