module Payment
  module Bradesco
    class GetAuthKey < ApplicationService

      DEFAULT_HEADERS = {
        'Content-Type'  => 'application/json; charset=utf8',
        'Accept'        => 'application/json',
        'Authorization' => "Basic #{ENV.fetch('BRADESCO_CRED')}"
      }

      URL = 'https://meiosdepagamentobradesco.com.br/SPSConsulta/Authentication/'.freeze

      def call
        res = RestClient.get(URL + ENV.fetch('BRADESCO_MERCHANT_ID'), DEFAULT_HEADERS)
        if res.code == 200
          body = JSON.parse(res.body)
          body['token']['token']
        end
      end

    end
  end
end
