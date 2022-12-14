# frozen_string_literal: true

module Backoffice
  class RafflesTicketsController < BackofficeController
    skip_before_action :authenticate_user!, only: %i[show tickets]

    def index
      @q = Raffle.includes(:raffle_tickets)
                 .where(raffle_tickets: { id: current_user.raffle_tickets })
                 .ransack(params[:q])
      @raffles = @q.result
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
        ::Raffles::ReserveTicketsService.call(valid_params)
        RemoveReservedRaffleTicketsWorker.perform_at(Time.now + ENV["CART_TIMEOUT"].to_i.minutes, valid_params[:order].id, true)
      end

      redirect_to backoffice_raffles_carts_path
    rescue StandardError => error
      flash[:error] = error.message
      @raffle = Raffle.find_by_hashid(params[:id])
      redirect_to backoffice_raffles_tickets_path(@raffle)
    end

    def show
      unless cookies[:token].present?
        cookies[:token] = { value: params[:token], expires: Time.now + 15.days }
      end
      @raffle = Raffle.find_by_hashid(params[:id])
      @raffle_number = Raffle.find_by_hashid(params[:id]).light_raffle_tickets
    end

    def tickets
      render json: { 
        data: Raffle.find_by_hashid(params[:id])
                    .light_raffle_tickets
                    .sort_by { |ticket| ticket.number.to_i }
                    .map { |ticket| [ticket.number.to_i, RaffleTicket.statuses[ticket.status]] }
      }
    end

    private

    def valid_params
      params.require(:raffle)
            .permit(:numbers)
            .merge(country: params[:country],
                   order: current_raffles_cart,
                   product: @raffle.product)
    end
  end
end
