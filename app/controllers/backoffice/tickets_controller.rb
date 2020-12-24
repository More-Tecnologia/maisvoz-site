module Backoffice
  class TicketsController < BackofficeController
    include Backoffice::TicketsHelper

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
        redirect_to backoffice_tickets_path
      else
        flash[:error] = @ticket.errors.full_messages.join(', ')
        render :new
      end
    end

    def show
      @ticket = Ticket.find(params[:id])
      @interaction = Interaction.new
      @interactions = @ticket.interactions.with_attached_files
                                          .includes(:user)
                                          .order(created_at: :desc)
    end

    private

    def tickets
      @q = Ticket.ransack(params[:q])

      @q.result
        .includes(:subject)
        .where(user: current_user)
        .or(@q.result.includes(:subject)
                     .where(attendant_user: current_user))
        .where(active: true)
        .order(created_at: :desc)
    end

    def valid_params
      params.require(:ticket)
            .permit(:title, :body, :subject_id, :attendant_user_id, files: [])
            .merge(user: current_user, status: :waiting)
    end
  end
end
