module Interspire
  class ContactDeleterWorker
    include Sidekiq::Worker

    def perform(email)
      Webhooks::Interspire::ContactDeleterService.call(email: email)
    end
  end
end
