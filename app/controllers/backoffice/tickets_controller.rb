module Backoffice
  class TicketsController < BackofficeController

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
        redirect_to backoffice_tickets_path(@ticket)
      else
        flash[:error] = @ticket.errors.full_messages.join(', ')
        render :new
      end
    end

    def show
      @ticket = Ticket.find(params[:id])
      @interaction = Interaction.new
    end

    private

    def tickets
      @q = Ticket.ransack(params[:q])
      @q.result
        .includes(:subject)
        .where(user_id: current_user.id)
        .or(@q.result.includes(:subject)
                     .where(attendant_user_id: current_user.id))
        .where(active: true)
        .order(created_at: :desc)
    end

    def valid_params
      params.require(:ticket)
            .permit(:title, :body, :subject_id, files: [])
    end

  end
end
