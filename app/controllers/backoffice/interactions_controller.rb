module Backoffice
  class InteractionsController < BackofficeController

    def new
      @interaction = Interaction.new
    end

    def create
      @ticket                = Ticket.find(params[:ticket_id])
      @interaction           = Interaction.new(valid_params)
      @interaction.ticket_id = @ticket.id
      @interaction.user_id   = current_user.id
      @interaction.active    = true

      if @interaction.save
        if @ticket.attendant_user.nil?
          @ticket.update!(attendant_user: current_user)
        end
        @ticket.update!(status: @interaction.status, finished_at: @interaction.created_at)
        flash[:success] = t('defaults.saving_success')
        redirect_to backoffice_tickets_path
      else
        flash[:error] = @interaction.errors.full_messages.join(', ')
        render :new
      end
    end

    def show
      @interaction = Interaction.find(params[:id])
    end

    private

    def interactions
      @q = Interaction.where(ticket_id: @ticket.id).ransack(params[:q])
      @q.result
        .includes(:user)
        .where(active: true)
        .order(created_at: :desc)
    end

    def valid_params
      params.require(:interaction)
            .permit(:body, :status, files: [])
    end

  end
end
