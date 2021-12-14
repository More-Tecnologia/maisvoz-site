module Interspire
  class ContactDeleterWorker
    include Sidekiq::Woker

    def perform(email)
      Webhooks::Interspire::ContactDeleterService.call(email: email)
    end
  end
end
