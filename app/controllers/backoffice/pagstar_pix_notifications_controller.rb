# frozen_string_literal: true

module Backoffice
  class PagstarPixNotificationsController < ApiController
    def create
      if params[:status] == 'approved' && params[:type] == 'pay'
        Payment::Pagstar::PixNotificationService.call(transaction_id: params[:transaction_id])
        head :ok
      end
    rescue StandardError => error
      render_error(:unprocessable_entity, error.message)
    end
  end
end
