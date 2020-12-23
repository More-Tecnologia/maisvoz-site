module Backoffice
  module Admin
    class TicketsController < AdminController
      def index
        @tickets = tickets.page(params[:page])
      end

      def new
        @ticket = Ticket.new
      end

      def create
        @ticket = Ticket.new(valid_params)

        if @ticket.save
          flash[:success] = t('defaults.saving_success')
          redirect_to backoffice_admin_tickets_path(@ticket)
        else
          flash[:error] = @ticket.errors.full_messages.join(', ')
          render :new
        end
      end

      def show
        @ticket = Ticket.find(params[:id])
        @interaction = Interaction.new
      end

      def destroy
        @ticket = Ticket.find(params[:id])

        if @ticket.update!(active: false)
          @ticket.interactions.update_all(active: false)

          flash[:success] = t('defaults.destroying_success')
          redirect_to backoffice_admin_tickets_path(@ticket)
        else
          flash[:error] = @ticket.errors.full_messages.join(', ')
          render :index
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

      def valid_params
        params.require(:ticket)
              .permit(:title, :body, :subject_id, :attendant_user_id, files: [])
              .merge(user: current_user)
      end
    end
  end
end
