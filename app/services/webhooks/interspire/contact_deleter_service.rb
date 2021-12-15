module Webhooks::Interspire
  class ContactDeleterService < Webhooks::BasicHookService
    def call
      response = add_user_to_request
      return response.dig('response') if response.dig('response', 'status') == 'SUCCESS'

      raise(response.dig('response', 'errormessage'))
    end

    private

    def initialize(args)
      @email = args[:email]
      @mailing_list_id = args[:mailing_list_id] || Rails.application.credentials.interspire_list_id
    end

    def add_user_to_request
      HTTParty.post(Rails.application.credentials.interspire_api_endpoint,
                    header: { 'Content-Type': 'application/xml' },
                    body: body)
              .parsed_response
    end

    def body
      "<xmlrequest>
       <username>#{Rails.application.credentials.interspire_username}</username>
       <usertoken>#{Rails.application.credentials.interspire_token}</usertoken>
       <requesttype>subscribers</requesttype>
       <requestmethod>DeleteSubscriber</requestmethod>
       <details>
       <emailaddress>#{@email}</emailaddress>
       <list>#{@mailing_list_id}</list>
       </details>
       </xmlrequest>"
    end
  end
end
