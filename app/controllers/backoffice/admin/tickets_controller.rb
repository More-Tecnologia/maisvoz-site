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
        @ticket[:status]  = 0
        @ticket[:user_id] = current_user.id
        @ticket[:active]  = true

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
          @ticket.interactions.each do |interaction|
            interaction.update!(active: false)
          end

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

        if params[:q].nil? || params[:q][:status_eq].blank?
          return @q.result 
                   .includes(:user, :subject)
                   .where(attendant_user: current_user).or(@q.result.includes(:user, :subject).where(attendant_user: nil))
                   .where(active: true)
                   .where.not(status: 2)
                   .order(created_at: :asc)
        end

        @q.result 
          .includes(:user, :subject)
          .where(attendant_user: current_user).or(@q.result.includes(:user, :subject).where(attendant_user: nil))
          .where(active: true)
          .order(created_at: :asc)
      end

      def valid_params
        params.require(:ticket)
              .permit(:title, :body, :subject_id, :attendant_user_id, files: [])
      end

    end
  end
end
