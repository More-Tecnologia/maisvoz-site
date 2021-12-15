module Interspire
  class ContactAdderWorker
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find(user_id)

      response = Webhooks::Interspire::ContactAdderService.call(email: user.email,
                                                                confirmed: 'yes')

      user.update!(interspire_code: response.dig('data'))
    end
  end
end
