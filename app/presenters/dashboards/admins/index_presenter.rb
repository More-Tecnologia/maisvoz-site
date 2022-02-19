# frozen_string_literal: true

module Dashboards
  module Admins
    class IndexPresenter
      def answered_tickets_count
        Ticket.select(:status).answered.count
      end

      def finished_tickets_count
        Ticket.select(:status).finished.count
      end

      def waiting_tickets
        Ticket.waiting
      end

      def waiting_tickets_count
        Ticket.select(:status).waiting.count
      end
    end
  end
end
