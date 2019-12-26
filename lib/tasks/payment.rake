namespace :payment do

  desc 'Check pending boletos'
  task check: :environment do
    Tasks::CheckPendingBoleto.call
  end

  desc 'Remove expired boletos'
  task expired: :environment do
    RemoveExpiredBoletoWorker.perform_async
  end
end
