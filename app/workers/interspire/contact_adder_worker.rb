module Interspire
  class ContactAdderWorker
    include Sidekiq::Worker

    def perform(user_id)
      user = User.find(user_id)
      names = user.name.split(/\s/)
      params = {
                 email: user.email,
                 confirmed: 'yes',
                 custom_fields: {
                   FirstName: names.first.strip,
                   LastName: names[1..names.length].join(' ')
                 }
              }

      response = Webhooks::Interspire::ContactAdderService.call(params)

      user.update!(interspire_code: response.dig('data'))
    end
  end
end
