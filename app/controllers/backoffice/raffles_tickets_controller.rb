# frozen_string_literal: true

module Backoffice
  class RafflesTicketsController < BackofficeController
    def index
      @q = current_user.raffle_tickets
                       .includes(:raffle)
                       .ransack(params)
      @raffles_tickets = @q.result
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(10)
    end

    def create
      @raffle = Raffle.find_by_hashid(params[:raffle][:id])
      ActiveRecord::Base.transaction do
        clean_shopping_cart
        clean_courses_cart
        clean_ads_cart
        Raffles::ReserveTicketsService.call(valid_params)
      end

      redirect_to backoffice_raffles_carts_path
    rescue StandardError => error
      flash[:error] = error.message
      @raffle = Raffle.find_by_hashid(params[:id])
      redirect_to backoffice_raffles_tickets_path(@raffle)
    end

    def show
      @raffle = Raffle.find_by_hashid(params[:id])
      @raffle_number = Raffle.find_by_hashid(params[:id]).light_raffle_tickets
      @banner = Product.raffle
                       .active
                       .includes(:raffle)
                       .limit(4)
    end

    def tickets
      render json: { 
        data: Raffle.find_by_hashid(params[:id]).light_raffle_tickets.map { |ticket| [ticket.number, RaffleTicket.statuses[ticket.status]] }
      }
    end

    private

    def valid_params
      params.require(:raffle)
            .permit(:numbers, :random_number_quantity)
            .merge(country: params[:country],
                   order: current_raffles_cart,
                   product: @raffle.product)
    end
  end
end
