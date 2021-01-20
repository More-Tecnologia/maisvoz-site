# frozen_string_literal: true

module Webhooks
  class BasicHookService < ApplicationService

    private

    def success?(response_code)
      response_code.to_s.start_with?('2')
    end

    def raise_error(response)
      body = JSON.parse(response.body)
      raise Exception, body['message']
    end
  end
end
