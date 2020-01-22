module Backoffice
  class SimCardsController < BackofficeController

    include Backoffice::SimCardsHelper

    def index
      @q = User.ransack(params[:q])
      @consultant = find_sim_card_cunsultant(current_user, params[:q][:username_eq]) if params[:q]
      @consultant_sim_cards = find_consultant_sim_cards(current_user, @consultant, params[:page])
    rescue Exception => error
      redirect_to backoffice_user_sim_cards_path, alert: error.message
    end

    def create
      @q = User.ransack(params[:q])
      @consultant = User.find_by(username: valid_params[:username])
      transfer_sim_cards_to(@consultant, valid_params[:iccids], current_user)
      @consultant_sim_cards = find_consultant_sim_cards(current_user, @consultant, params[:page])
      render :index, success: t('.success')
    rescue Exception => error
      flash[:error] = error.message
      redirect_to backoffice_user_sim_cards_path(current_user)
    end

    private

    def valid_params
      params.require(:sim_cards).permit(:username, iccids: [])
    end

  end
end
