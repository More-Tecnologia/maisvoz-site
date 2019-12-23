class RemoveExpiredBoletoWorker
  include Sidekiq::Worker

  def perform
    Payment::RemoveExpiredBoleto.call
  end
end
