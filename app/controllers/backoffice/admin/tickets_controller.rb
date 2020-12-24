module Backoffice
  module Admin
    class TicketsController < AdminController
      include Backoffice::TicketsHelper

      def index
        @tickets = tickets.page(params[:page])
      end

      def new
        @ticket = Ticket.new
      end

      def show
        @ticket = Ticket.find(params[:id])
        @interaction = Interaction.new
        @interactions = @ticket.interactions.with_attached_files
                                            .includes(:user)
                                            .order(created_at: :desc)
      end

      def destroy
        @ticket = Ticket.find(params[:id])

        if @ticket.update!(active: false)
          @ticket.interactions.update_all(active: false)

          flash[:success] = t('defaults.destroying_success')
          redirect_to backoffice_admin_tickets_path(@ticket)
        else
          flash[:error] = @ticket.errors.full_messages.join(', ')
          redirect_to :index
        end
      end

      private

      def tickets
        @q = Ticket.ransack(params[:q])

        query = @q.result
                 .includes(:user, :subject)
                 .where(attendant_user: current_user)
                 .or(@q.result.includes(:user, :subject).where(attendant_user: nil))
                 .where(active: true)
                 .order(:created_at)
        query.merge!(Ticket.not_finished) if params[:q].nil? || params[:q][:status_eq].blank?
        query
      end
    end
  end
end
