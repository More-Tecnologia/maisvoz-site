namespace :nodes_still_active do
  desc "TODO"
  task verify: :environment do
    NodesActiveUntilTodayVerifierWorker.perform_async
  end

end
