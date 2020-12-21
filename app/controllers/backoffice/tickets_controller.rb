module Backoffice
  class TicketsController < BackofficeController

    def index
      # @tickets = current_user.tickets.includes(:payment_transaction)
      #                                .where.not(status: :cart)
      #                                .order(created_at: :desc)
    end

    def show
      # @ticket = Ticket.find(params[:id])
    end

  end
end
