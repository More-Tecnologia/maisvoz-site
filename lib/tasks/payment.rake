namespace :payment do

  desc 'Check pending boletos'

  task check: :environment do
    Tasks::CheckPendingBoleto.call
  end

  task generate_invoices: :environment do
    Subscriptions::GenerateInvoices.new.call
  end

end
