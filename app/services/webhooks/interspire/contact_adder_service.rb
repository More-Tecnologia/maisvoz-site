module Webhooks::Interspire
  class ContactAdderService < Webhooks::BasicHookService
    def call
      response = add_user_to_request
      return response.dig('response') if response.dig('response', 'status') == 'SUCCESS'

      raise(response.dig('response', 'errormessage'))
    end

    private

    CUSTOM_FIELD_IDS = { FirstName: 2, LastName: 3 }.with_indifferent_access.freeze

    def initialize(args)
      @email = args[:email]
      @confirmed = args[:confirmed]
      @valid_custom_fields = (args[:custom_fields] || {}).with_indifferent_access
                                                         .slice(*CUSTOM_FIELD_IDS.keys)
    end

    def add_user_to_request
      HTTParty.post(Rails.application.credentials.interspire_api_endpoint,
                    header: { 'Content-Type': 'application/xml' },
                    body: body)
              .parsed_response
    end

    def body
      "<xmlrequest>\
      <username>#{Rails.application.credentials.interspire_username}</username>\
      <usertoken>#{Rails.application.credentials.interspire_token}</usertoken>\
      <requesttype>subscribers</requesttype>\
      <requestmethod>AddSubscriberToList</requestmethod>\
      <details>\
      <emailaddress>#{@email}</emailaddress>\
      <mailinglist>#{Rails.application.credentials.interspire_list_id}</mailinglist>\
      <format>html</format>\
      <confirmed>#{@confirmed}</confirmed>\
      <customfields>#{customfield_itens}</customfields>
      </details>\
      </xmlrequest>"
    end

    def customfield_itens
      itens = ''
      @valid_custom_fields.map do |field, value|
        itens += "<item>
                  <fieldid>#{CUSTOM_FIELD_IDS[field]}</fieldid>
                  <value>#{value}</value>
                  </item>"
      end
      itens
    end
  end
end
