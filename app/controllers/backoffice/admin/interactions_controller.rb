module Backoffice
  module Admin
    class InteractionsController < AdminController
      def new
        @interaction = Interaction.new
      end

      def create
        @ticket = Ticket.find(params[:ticket_id])
        @interaction = @ticket.interactions.build(valid_params)

        if @interaction.save
          attrs = { status: @interaction.status }
          attrs.merge(attendant_user: current_user) if @ticket.attendant_user.nil?
          @ticket.update!(attrs)

          flash[:success] = t('defaults.saving_success')
          redirect_to backoffice_admin_tickets_path
        else
          flash[:error] = @interaction.errors.full_messages.join(', ')
          render :new
        end
      end

      def show
        @interaction = Interaction.find(params[:id])
      end

      private

      def valid_params
        params.require(:interaction)
              .permit(:body, :status, files: [])
              .merge(user: current_user)
      end
    end
  end
end
