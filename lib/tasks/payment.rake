namespace :payment do

  desc 'Check pending boletos'

  task check: :environment do
    Tasks::CheckPendingBoleto.call
  end
end
