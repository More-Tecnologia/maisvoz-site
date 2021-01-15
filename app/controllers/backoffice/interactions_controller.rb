module Backoffice
  class InteractionsController < BackofficeController

    def new
      @interaction = Interaction.new
    end

    def create
      @ticket = Ticket.find(params[:ticket_id])
      @interaction = @ticket.interactions.build(valid_params)

      if @interaction.save
        @ticket.update!(status: @interaction.status)

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
            .merge(user: current_user)
    end

  end
end
