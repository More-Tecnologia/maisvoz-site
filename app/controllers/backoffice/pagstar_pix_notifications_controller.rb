# frozen_string_literal: true

module Backoffice
  class PagstarPixNotificationsController < ApiController
    def create
      Payment::Pagstar::PixNotificationService.call(transaction_code: transaction_code)
    rescue StandardError => error
      render_error(:unprocessable_entity, error.message)
    end

    private

    def transaction_code
      notification = params.permit(:transaction_id)
      notification[:transaction_id]
    end
  end
end
